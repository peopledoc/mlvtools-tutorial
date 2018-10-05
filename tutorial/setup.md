# Tutorial Setup

This is the setup section for realistic tutorial.

## 1. Create Project Structure

All resource files needed in this tutorial are provided in `ml-poc-version/resources`.
The structure of the project will be created along the tutorial.

If it is not already done, clone the repository on the tutorial branch.

    git clone -b tutorial https://github.com/peopledoc/mlv-tools-tutorial
    cd ml-poc-version

Create your working branch

    git checkout -b working
    

Create the project base structure.

    make init-struct

Following structure must be created:

    ├── poc
    │   ├── pipeline
    │   │   ├── __init__.py
    │   │   ├── notebooks        # contains Jupyter notebooks (one by pipeline step)
    |   |   └── steps            # contains generated configurable Python 3 scripts
    |   ├── data                 # contains pipeline data
    │   └── commands
    │       └── dvc              # contains dvc command wrapped in a bash script
    ...
    ├── resources                # contains Jupyter notebooks needed in this tutorial
    │   ├── 01_Extract_dataset.ipynb
    │   ├── 02_Tokenize_text.ipynb
    │   ├── 03_bis_Classify_text.ipynb
    │   ├── 03_Classify_text.ipynb
    │   └── 04_Evaluate_model.ipynb
    ...

> It is not mandatory to follow this structure, it is just an example for this tutorial.

## 2. Prepare Environment

Create a virtual environment using **conda** or **virtualenv**, then activate it.
Then setup the project.

    make develop

## 3. Initialize DVC Project
**DVC** works on top of **git** repositories. Run **DVC** initialization in a **git**
 repository directory to create **DVC meta files**.

    dvc init

The directory `.dvc` should be created in the project root directory.

Add it under git versioning:

    git commit -m 'Tutorial setup: dvc init' ./.dvc/

## 4. Create MLV-tools Project Configuration

Using **MLV-tools**, it can be repetitive to repeat output paths parameters for each `ipynb_to_python` 
and `gen_dvc` command. 

It is possible to provide a configuration to declare project structure and
 let **MLV-tools** generates output path.
(For more information see [documentation](https://github.com/mlflow/mlflow))

    make mlvtools-conf

The configuration file `./.mlvtools` should be created.

Add it under git versioning:

    git add .mlvtools && git commit -m 'Tutorial setup: dvc init'

## 5. Add Git Hooks and Filters

### 5.1 Automatise Jupyter Notebook Cleanup

Usually it is not useful to version **Jupyter notebook** embedded outputs. Sometimes it is even forbidden,
if you work on production data for example. To avoid mistakes, use git pre-commit or git filter to cleanup
**Jupyter notebook** outputs. Several tools can do that, 
see for example [nbstripout](https://github.com/kynan/nbstripout).

    pip install --upgrade nbstripout
    nbstripout --install

With **nbstripout** git filter, **Jupyter notebook** outputs are cleaned on each branch on check-in. That means 
when you will commit a change you will keep outputs into the notebook to continue working.
 But those outputs will not be sent to the remote server when you push. 
 Notebook outputs are also excluded from the git diff.

## 6. Get Tutorial Data

This tutorial is based on data from [20_newsgroup](http://scikit-learn.org/stable/datasets/).
Run the following command to download them.

    make download-data

Data are stored in `./poc/data/20news-bydate_py3.pkz`.


You reached the end of the setup part, see [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md)

Or [go back to README](../README.md)
