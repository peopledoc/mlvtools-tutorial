# Machine Learning Pipeline Versioning Tutorial

The aim of this repository is to show a way to handle **pipelining** and **versioning**
of a **Machine Learning project**.

Processes exposed during this tutorial are based on 3 tools:

* [DVC](https://github.com/iterative/dvc)
* [MLflow tracking](https://github.com/mlflow/mlflow)
* [mlvtools](https://github.com/peopledoc/mlvtools)

Use cases are based on a text classification task on 20newsgroup dataset. A *dummy*
tutorial is also available to show tools mechanisms.

**Prerequisites**

For this tutorial, you must be familiar with the following tools:

- virtualenv or condaenv
- make
- git
- python

## Tools Overview

DVC is an open-source version control system for Machine Learning projects. It is used
for versioning and sharing Machine Learning data, and reproducing Machine Learning
experiments and pipeline stages.

mlvtools provides tools to generate Python scripts and DVC commands from Jupyter
Notebooks.

Please have a look at the
[presentation](https://peopledoc.github.io/mlvtools-tutorial/talks/pyData/presentation.html).

## Our main features

* Notebook parametrized conversion ([mlvtools](https://github.com/peopledoc/mlvtools))
* Pipelining ([DVC](https://github.com/iterative/dvc) and
  [mlvtools](https://github.com/peopledoc/mlvtools))
* Data x Code x Hyperparameters versioning ([DVC](https://github.com/iterative/dvc) and
  [mlvtools](https://github.com/peopledoc/mlvtools))

## Standard Versioning Process Establishment

**Goal:** find a way to version code, data and pipelines.

### Initial project

Starting from an existing project composed of multiple Python modules and a set of
Jupyter notebooks, we want to create an automated pipeline in order to version, share
and reproduce experiments.

            
    │── classifier
    │   ├── aggregate_classif.py
    │   ├── __init__.py
    │   ├── extract.py
    │   └── ...
    │── notebooks
    │   ├── Augment train data.ipynb
    │   ├── Check data and split and train.ipynb
    │   ├── Extract data.ipynb
    │   ├── Learn text classifier.ipynb
    │   ├── Learn aggregated model.ipynb
    │   ├── Preprocess image data.ipynb
    │   └── Train CNN classifier on image data.ipynb
    │── README.md
    │── requirements.yml
    │── setup.cfg
    │── setup.py

The data flow is processed by applying steps and intermediary results are versioned
using metadata files. These steps are defined in Jupyter notebooks, which are then
converted to Python scripts.

Keep in mind that:

 - The reference for the code of the step remains in the Jupyter notebook
 - Pipelines are structured according to their inputs and outputs
 - Hyperparameters are pipeline inputs

### Project after refactoring

    │── classifier
    │   ├── aggregate_classif.py
    │   ├── __init__.py
    │   ├── extract.py
    │   └── ...
    │── notebooks
    │   ├── Augment train data.ipynb
    │   ├── Check data and split and train.ipynb
    │   ├── Extract data.ipynb
    │   ├── Learn text classifier.ipynb
    │   ├── Learn aggregated model.ipynb
    │   ├── Preprocess image data.ipynb
    │   └── Train CNN classifier on image data.ipynb
    │── pipeline
    │   ├── dvc                                        ** DVC pipeline steps
    │   │   ├─ mlvtools_augment_train_data_dvc
    │   │   ├─ ..
    │   ├── scripts                                    ** Notebooks converted into Python configurable scripts
    │   │   ├─ mlvtools_augment_train_data.py
    │   │   ├─ ..
    │── README.md
    │── requirements.yml
    │── setup.cfg
    │── setup.py


### Applying the process

For each Jupyter notebook a Python parameterizable and executable script is generated.
This script makes it easier to version code and automate pipeline executions.

Pipelines are composed of DVC steps. Those steps can be generated directly from the
Jupyter notebook based on parameters described in the Docstring. (notebook -> python
script -> DVC command)

Each time a DVC step is run a DVC meta file (`[normalized_notebook_name].dvc`) is
created. This metadata file represents a pipeline step, it is the DVC result of a step
execution. Those files must be tracked using Git.  They are used to reproduce
a pipeline.

**Application:**

For each step in the tutorial the process remain the same.

1. Write a Jupyter notebook which corresponds to a pipeline step. (See Jupyter notebook
   syntax section in [mlvtools documentation](https://github.com/peopledoc/mlvtools))
1. Test your Jupyter notebook.
1. Add it under git.
1. Convert the Jupyter notebook into a configurable and executable Python script
   using `ipynb_to_python`.
   ```
   ipynb_to_python -n ./pipeline/notebooks/[notebook_name] -o ./pipeline/steps/[python_script_name]
   ```

1. Ensure Python executable and configurable script is well created into `./pipeline/steps/[python_script_name]`.
   ```
   ./pipeline/steps/[python_script_name] -h
   ```
1. Create a DVC commands to run the Python script using DVC.
   ```
   gen_dvc -i ./pipeline/steps/[python_script_name] \
           --out-dvc-cmd ./scripts/cmd/[dvc_cmd_name]
   ```
1. Ensure DVC command is well created.
1. Add generated command and Python script under git.
1. Add step inputs under DVC.
1. Run DVC command `./scripts/cmd/[dvc_cmd_name]`.
1. Check DVC meta file is created `./[normalized notebook _name].dvc`
1. Add DVC meta file under git


## Key Features

|Need| Feature|
|:---|:---|
| Ignore notebook cell | `# No effect` |
| DVC input and ouptuts | `:dvc-in`, `:dvc-out`|
| Add extra parameters | `:dvc-extra`|
| Write DVC whole command | `:dvc-cmd`|
| Convert Jupiter Notebook to Python script | `ipynb_to_python`|
| Generate DVC command | `gen_dvc`|
| Create a pipeline step from a Jupiter Notebook | `ipynb_to_python`, `gen_dvc` |
| Add a pipeline step with different IO | Copy DVC step then edit inputs, outputs and meta file name |
| Reproduce a pipeline | `dvc repro [metafile]`|
| Reproduce a pipeline with no cache | `dvc repro -f [metafile]`|
| Reproduce a pipeline after an algo change | `dvc repro -f [metafile]` or run impacted step individually then complete the pipeline.|

It is allowed to modify or duplicate a DVC command to change an hyperparameter or run
a same step twice with different parameters.

It is a bad idea to modify generated Python scripts. They are generated from Jupyter
notebooks, so changes should be done in Jupyter notebooks and then scripts should be
re-generated.

## Tutorial

### Environment

To complete this tutorial clone this repository:

```shell
git clone https://github.com/peopledoc/mlvtools-tutorial
```

Create and a Python virtual environment, and activate it:

```shell
virtualenv --python python3 venv
source venv/bin/activate
```

Install requirements:

```shell
make develop
```

All other steps are explained in each use case.

### Cases

* [How DVC works](./tutorial/dvc_overview.md)
* [mlvtools pipeline features (on simple cases)](./tutorial/pipeline_features.md)
* Going further with more realistic use cases:
  * [Use Case 1: Build and Reproduce a Pipeline](./tutorial/use_case1.md)
  * [Use Case 2: Create a new version of a pipeline](./tutorial/use_case2.md) (Run an
    experiment)
  * [Use Case 3: Build a Pipeline from an Existing Pipeline](./tutorial/use_case3.md)
  * [Use Case 4: Hyperparameter optimisation and fine-tuning](./tutorial/use_case4.md)


## Talks

* [PyData Paris - March 2019
  Meetup](https://www.meetup.com/fr-FR/PyData-Paris/events/259187805/):
  [talk](https://peopledoc.github.io/mlvtools-tutorial/talks/pyData/presentation.html)
* [PyData Amsterdam - May
  2019](https://pydata.org/amsterdam2019/schedule/presentation/32/how-to-easily-set-up-and-version-your-machine-learning-pipelines-using-dvc-and-mlv-tools/):
  [tutorial slides](https://peopledoc.github.io/mlvtools-tutorial/talks/workshop/presentation.html) and [video](https://www.youtube.com/watch?v=rUTlqpcmiQw)
