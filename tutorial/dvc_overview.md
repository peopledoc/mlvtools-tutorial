Data Version Control
====================


Overview
---------
- Each run is tracked and is reproducible
- Each run can be a part of a pipeline
- A complete pipeline is reproducible according to a chosen version 
(ie chosen commit)
- The cache mechanisme allows to reproduce sub-pipelines (only part with outdated dependencies)
- Several kind of storage can be configure to handle data file (AWS S3, Azure, 
Google Cloud Storage, SSH, HDFS)


- Need to be rigorous: inputs and outputs of each run must be explicitly 
specified to be handle as dependencies
- Commands can't be run through a Jupyter Notebook



How it works
------------

**DVC** depends on **Git**. You need to have a Git repository and to manage yourself
your *code* versioning.
You must consider **DVC** as a git extension.

1. As usual, create a git repository and version your files
2. Activate DVC  (`dvc init`)
3. Add data files and manage their versioning with DVC (`dvc add [my_file]`).
   At this step DVC put data files in its cache and it creates meta files to
   identify them.
   (see section **Add data file**)
4. Commit meta files using Git to save a version of a pipeline



Small tutorial
---------------

### Install DVC

    pip install dvc
    
### Setup a git environment
    
    mkdir test_dvc
    cd test_dvc
    
    git init 
    # Create a python script which takes a file as input, reads it, writes it in upper case
    mkdir code
    echo '#!/usr/bin/env python' > code/python_script.py
    echo -e "with open('./data/input_file.txt', 'r') as fd, open('./results/output_file.txt', 'w') \
    as wfd:\n    wfd.write(fd.read().upper())" >> code/python_script.py
    chmod +x ./code/python_script.py
    
    # Commit you script
    git add ./code/python_script.py
    git commit -m 'Initialize env'
    
### Setup DVC environment

    # In ./test_dvc (top level directory)
    dvc init
    git commit -m 'Initialize dvc'
    
### Add a data file

    # Create a data fiel for the exemple
    mkdir data
    echo "This is a text" > data/input_file.txt
    
    dvc add data/input_file.txt
    
Here it is possible to check meta file is created running `git status data`, real file
is ignored by git `cat ./data/.gitignore` and cache entry is created `ls -la .dvc/cache/`

    # Commit meta files in git
    git add .
    git commit -m "Add input data file"

### Run a step 

    dvc run -d [input file] -o [output file] [cmd]
   
    mkdir results
    dvc run -d ./data/input_file.txt -o ./results/output_file.txt ./code/python_script.py
    
Check output file and meta file are generated *./results/output_file.txt*, *./output_file.txt.dvc*


### Run a pipeline
A pipeline is composed of several steps, so we need to create at least one more step here.

    # Run an other step and create a pipeline 
    MY_CMD="cat ./results/output_file.txt | wc -c > ./results/nb_letters.txt" 
    dvc run -d ./results/output_file.txt -o ./results/nb_letters.txt -f MyPipeline.dvc $MY_CMD
    
See the result
    
    cat ./results/nb_letters.txt
    
A this step the file *./MyPipeline.dvc* represent the pipeline for the current version of files and data

    # Reproduce the pipeline
    dvc repro MyPipeline.dvc
    
Nothing happened because nothing has changed try `dvc repro MyPipeline.dvc -v`

    # Force the pipeline run
    dvc repro MyPipeline.dvc -v -f
    
    git add .
    git commit -m 'pipeline creation'
    
### Modify the input and re-run

    echo "new input" >> data/input_file.txt
    
    dvc repro MyPipeline.dvc -v
    
    cat ./results/nb_letters.txt
    
    git commit -am 'New pipeline version'
   
   
### See pipelines steps
    
    dvc pipeline show MyPipeline.dvc
 
Need to be rigorous
-------------------

- inputs and outputs of each run must be explicitly 
specified to be handle as dependencies
- when you modify a data file you need to run the associated step to be able 
to version it (or reproduce the whole pipeline using the cache mechanism)

Various
-------

See [Data Version Control documentation](https://github.com/iterative/dvc)

See [Data Version Control tutorial](https://blog.dataversioncontrol.com/data-version-control-tutorial-9146715eda46)
