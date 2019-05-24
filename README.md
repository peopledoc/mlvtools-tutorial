# POC versioning Machine Learning pipeline

The aim of this repository is to show a way to handle **pipelining** and **versioning**
of a **Machine Learning project**.

Processes exposed during this tutorial are based of 3 existing tools:

 - [Data Science Version Control](https://github.com/iterative/dvc) or DVC
 - [MLflow tracking](https://github.com/mlflow/mlflow)
 - [MLV-tools](https://github.com/peopledoc/ml-versioning-tools)
 
Use cases are based on a text classification task on 20newsgroup dataset. A *dummy* tutorial is also available
to show tools mechanisms.


**Requirements:**

Before starting, you must be familiar with the following commands: 
- virtualenv or condaenv
- make
- git
- python3


## Tools Overview

DVC: an open-source tool for data science and machine learning projects. Use to version, share and reproduce.

MLflow tracking: API and UI to log and visualize metrics obtained during experiments.

MLV-tools: provides a set of tools to enhance Jupyter Notebooks conversion and DVC versioning and pipelining.  


Please have a look to the [presentation](https://peopledoc.github.io/mlv-tools-tutorial/talks/pyData/presentation.html)


## Our main features

- Notebook parametrized conversion ([MLV-tools](https://github.com/peopledoc/ml-versioning-tools))

- Pipelining ([DVC](https://github.com/iterative/dvc) and [MLV-tools](https://github.com/peopledoc/ml-versioning-tools))

- Data x Code x Hyperparameters versioning ([DVC](https://github.com/iterative/dvc) and [MLV-tools](https://github.com/peopledoc/ml-versioning-tools))


## Standard Versioning Process Establishment

**Goal:** find a way to version code, data and pipelines.

#### Existing project

Starting from an existing project composed of Python 3 module(s) and a set of **Jupyter notebooks**,
we want to create an automated pipeline in order to version, share and reproduce experiments.

            
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
 
The data flow is processed by applying steps and intermediary results are versioned using metadata files. These steps are defined in **Jupyter notebooks**, which are then converted to Python scripts.

Keep in mind that:

 - The reference for the code of the step remains in **Jupyter notebook** 
 - Pipelines are structured according to their inputs and outputs
 - Hyperparameters are pipeline inputs
 
#### Project after refactoring

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
    │   ├── scripts                                    ** Notebooks converted into Python 3 configurable scripts
    │   │   ├─ mlvtools_augment_train_data.py
    │   │   ├─ ..
    │── README.md
    │── requirements.yml
    │── setup.cfg
    │── setup.py


**Notebooks converted into configurable Python 3 scripts**: obtained by **Jupyter notebook** conversion.

**DVC pipeline steps**: DVC command applied on generated Python 3 scripts


#### Applying the process

For each **Jupyter notebook** a **Python 3** parameterizable and executable script is generated. It is the way to 
version code and be able to automatize its run.

Pipelines are composed of **DVC** steps. Those steps can be generated directly from the **Jupyter notebook** based
on parameters describe in the Docstring. (notebook -> python script -> DVC command)

Each time a **DVC** step is run a **DVC meta file** (`[normalize_notebook_name].dvc`) is created. This metadata
 file represent a pipeline step, it is the DVC result of a step execution. Those files must be tacked using Git.
They are used to reproduce a pipeline..

**Application:**
>For each step in the tutorial the process remain the same.
   
   1. Write a **Jupyter notebook** which correspond to a pipeline step. (See **Jupyter notebook** syntax section in 
   [MLVtools documentation](https://github.com/peopledoc/ml-versioning-tools))
   2. Test your **Jupyter notebook**.
   3. Add it under git.
   4. Convert the **Jupyter notebook** into a configurable and executable **Python 3** script using *ipynb_to_python*.
       
            ipynb_to_python -n ./pipeline/notebooks/[notebook_name] -o ./pipeline/steps/[python_script_name]
            
   5. Ensure **Python 3** executable and configurable script is well created into `./pipeline/steps/[python_script_name]`.
            
            ./pipeline/steps/[python_script_name] -h
    
   6. Create a **DVC** commands to run the **Python 3** script using **DVC**.
   
            gen_dvc -i ./pipeline/steps/[python_script_name] \
                        --out-dvc-cmd ./scripts/cmd/[dvc_cmd_name] 

   7. Ensure **DVC** command is well created.
   8. Add generated command and **Python 3** script under git.
   9. Add step inputs under **DVC**.
   10. Run **DVC** command `./scripts/cmd/[dvc_cmd_name]`.
   11. Check **DVC meta file** is created `./[normalize notebook _name].dvc`
   12. Add **DVC meta file** under git/
   

## Key Features
|Need| Feature|
|:---|:---|
| Ignore notebook cell | # No effect |
| DVC input and ouptuts | **:dvc-in**, **:dvc-out**|
| Add extra parameters | **:dvc-extra**|
| Write DVC whole command | **:dvc-cmd**|
| Convert Jupiter Notebook to Python 3 script | **ipynb_to_python**|
| Generate DVC command | **gen_dvc**|
| Create a pipeline step from a Jupiter Notebook | ipynb_to_python, gen_dvc |
| Add a pipeline step with different IO | Copy **DVC** step then edit inputs, outputs and meta file name |
| Reproduce a pipeline | **dvc repro [metafile]**|
| Reproduce a pipeline with no cache | **dvc repro -f [metafile]**|
| Reproduce a pipeline after an algo change | **dvc repro -f [metafile]** or run impacted step individually then complete the pipeline.|


It is allowed to modify or duplicate a **DVC** command to change an hyperparameter or run a same step twice with
different parameters.

It is a bad idea to modify generated **Python 3** scripts. They are generated from **Jupyter notebooks**, so changes 
should be done in them and then scripts should be re-generated.



## Tutorial

#### Environment

To complete this tutorial clone this repository:

    git clone https://github.com/peopledoc/mlv-tools-tutorial
    
Activate your **Python 3** virtual environment.

Install requirements:

    make develop
    
All other steps are explain in each use cases.

#### Cases

- [How DVC works](./tutorial/dvc_overview.md)

- [MLV-tools pipeline features (on simple cases)](./tutorial/pipeline_features.md)

- Going further with more realistic use cases:

    - [Use Case 1: Build and Reproduce a Pipeline](./tutorial/use_case1.md)
    - [Use Case 2: Create a new version of a pipeline](./tutorial/use_case2.md) (Run an experiment)
    - [Use Case 3: Build a Pipeline from an Existing Pipeline](./tutorial/use_case3.md)
    - [Use Case 4: Hyperparameter optimisation and fine-tuning](./tutorial/use_case4.md)


## Talks

- [PyData Paris - March 2019 Meetup](https://www.meetup.com/fr-FR/PyData-Paris/events/259187805/): [talk](https://peopledoc.github.io/mlv-tools-tutorial/talks/pyData/presentation.html)
- [PyData Amsterdam - May 2019](https://pydata.org/amsterdam2019/schedule/presentation/32/): [tutorial](https://peopledoc.github.io/mlv-tools-tutorial/talks/tutorial/presentation.html)