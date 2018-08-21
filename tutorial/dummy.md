# Dummy Pipeline

The aim of this tutorial is to show how **MLV-tools**, **DVC** and **MLflow tracking** work on a trivial case.

The pipeline converts an unreadable input into a readable text. It is composed with:

- a basic step with only input and output parameters (#1, #4) 
- a step with more parameters (#2)
- a step with a specific DVC command (#3)
- a step using MLflow (#5)

                                                          * dummy_pipeline_feed.txt                       
                                                          *
                                        +-------------------------------------+                                      
                                        | #1 mlvtools_step1_sanitize_data.dvc |                                      
                                        +-------------------------------------+                                      
                                                          *                                                       
                                                          *  sanitized_data.txt                                                     
                                                          *                                                       
                                          +----------------------------------+                                       
                                          | #2 mlvtools_step2_split_data.dvc |                                       
                                          +----------------------------------+                                       
                                      *******                            *******                                  
               binary_data.txt   *****                                          *****     octal_data.txt                          
                             ****                                                    ****                         
         +----------------------------------------+                                +---------------------------------------+  
         | #3 mlvtools_step3_convert_binaries.dvc |                                | # 4 mlvtools_step4_convert_octals.dvc |  
         +----------------------------------------+                                +---------------------------------------+  
                                          *******                            *******                                  
                  data_conv_from_octal.txt       *****                  *****       data_conv_from_octal.txt                                  
                                                      ****          ****                                              
                                              +---------------------------------+                                        
                                              | #5 mlvtools_step5_sort_data.dvc |                                        
                                              +---------------------------------+  
                                                               *
                                                               *  result.txt
        
  

It is also in view to explore how the pipeline repro feature works:
- with the cache
- without the cache
- modifying input and running the whole pipeline 
- modifying input and running a sub-pipeline 
- modifying the code
- modifying an hyperparameter


# Setup 

1. Start from *remote tutorial branch* and create a *dummy* branch

        git checkout -b dummy-pipeline

2. Create a dummy structure to store data, **Jupyter Notebook**, generated scripts and commands.

        mkdir -p ./dummy/pipeline/notebooks
        mkdir -p ./dummy/pipeline/steps
        mkdir -p ./dummy/dvc
        mkdir -p ./dummy/data
    
3. Create pipeline input data

        make dummy-input
    
4. Create dummy conf
    
        make dummy-conf

> Using **MLV-tools**, it can be repetitive to repeat output paths parameters for each `ipynb_to_python` 
  and `gen_dvc` command.  
>  It is possible to provide a configuration to declare project structure and
   let **MLV-tools** generates output path.
  (For more information see [documentation](https://github.com/mlflow/mlflow))
    
5. Initialize **DVC**
    
        dvc init
        
> **DVC** works on top of **git** repositories. Run **DVC** initialization in a **git**
   repository directory to create **DVC meta files**.
    
6. Version setup under **git**

        git add ./dummy *.dvc
        git commit -m 'Dummy pipeline setup'    
        
    
# Step 1: Sanitize Data

This step sanitizes pipeline input data. It is a simple step with only input and output parameters.
It is based on `step1_sanitize_data.ipynb` notebook.


|||
| :--- | :--- |
| **Step Input**: | `./dummy/data/dummy_pipeline_feed.txt` |
|||
| **Step Output**: | `./dummy/data/sanitized_data.txt`|
|||
|**Generated files**:| `./dummy/pipeline/steps/mlvtools_step1_sanitize_data.py`|
| | `./dummy/dvc/mlvtools_step1_sanitize_data_dvc`|

### Get the Pipeline Step Resources
 
1. Add the pipeline input file under **DVC** versioning.

        dvc add ./dummy/data/dummy_pipeline_feed.txt

2. Copy the `step1_sanitize_data.ipynb` from the resources directory to the poc project:

        cp ./resources/dummy/step1_sanitize_data.ipynb ./dummy/pipeline/notebooks/

3. Open the notebook, read info about parameters and try it.


### Generate Python 3 Script and DVC Pipeline Step 

1. Convert the **Jupyter Notebook** into a parameterized **Python 3 script** using `ipynb_to_python`.

       ipynb_to_python -n ./dummy/pipeline/notebooks/step1_sanitize_data.ipynb  

   Ensure `./dummy/pipeline/steps/mlvtools_step1_sanitize_data.py` is well created.

2. Create a **DVC** command to run the **Python 3** script using **DVC**.

       gen_dvc -i ./dummy/pipeline/steps/mlvtools_step1_sanitize_data.py

   Ensure `./dummy/dvc/mlvtools_step1_sanitize_data_dvc` is created.

### Run the Pipeline Step


1. Run the **DVC** command.

       ./dummy/dvc/mlvtools_step1_sanitize_data_dvc

2. Ensure the output file is well created.
    
       See ./dummy/data/sanitized_data.txt
       
3. Ensure the **DVC** meta file is well created. 

        See ./mlvtools_step1_sanitize_data.dvc
        
   This file represents this pipeline step. It is used for the pipeline reproducibility.

### Track Files Under Git Versioning

**DVC** meta files, notebook and generated scripts should be tracked under **git**.

    git add *.dvc ./dummy/
    git commit -m 'Dummy pipeline step1' 

> For next step the principle stay the same but steps are aggregated in the same code section to make it more practical.


# Step 2: Split Data

This step splits data into binary and octal values. It is a simple step which take one parameter which
is neither an input nor an output. The *extra parameter* is the number of bits in a binary value. 

This extra parameter is provided to the pipeline step using **:dvc-extra** in the notebook Docstring. 

It is based on `step2_split_data.ipynb` notebook.


|||
| :--- | :--- |
| **Step Input**: | `./dummy/data/sanitized_data.txt` |
|||
| **Step Output**: | `./dummy/data/octal_data.txt`|
| | `./dummy/data/binary_data.txt` |
|||
|**Generated files**:| `./dummy/pipeline/steps/mlvtools_step2_split_data.py`|
| | `./dummy/dvc/mlvtools_step2_split_data_dvc`|

    # Copy Jupyter Notebook
    cp ./resources/dummy/step2_split_data.ipynb ./dummy/pipeline/notebooks/
    
    # Generate Python script and DVC pipeline step
    ipynb_to_python -n ./dummy/pipeline/notebooks/step2_split_data.ipynb  
    gen_dvc -i ./dummy/pipeline/steps/mlvtools_step2_split_data.py

    # Run the pipeline step
    ./dummy/dvc/mlvtools_step2_split_data_dvc
    
    # Version files
    git add *.dvc ./dummy/
    git commit -m 'Dummy pipeline step2' 


# Step 3: Convert Binary Values 

This step converts binary values into the corresponding Ascii code.
It uses (even if it is not necessary in this case) **dvc-cmd** in Docstring to be able to write the whole **DVC**
 command. The feature is available for complex cases.
 
It is based on `step3_convert_binaries.ipynb` notebook.


|||
| :--- | :--- |
| **Step Input**: | `./dummy/data/binary_data.txt` |
|||
| **Step Output**: | `./dummy/data/data_conv_from_bin.txt`|
|||
|**Generated files**:| `./dummy/pipeline/steps/mlvtools_step3_convert_binaries.py`|
| | `./dummy/dvc/mlvtools_step3_convert_binaries_dvc`|

    # Copy Jupyter Notebook
    cp ./resources/dummy/step3_convert_binaries.ipynb ./dummy/pipeline/notebooks/
    
    # Generate Python script and DVC pipeline step
    ipynb_to_python -n ./dummy/pipeline/notebooks/step3_convert_binaries.ipynb  
    gen_dvc -i ./dummy/pipeline/steps/mlvtools_step3_convert_binaries.py

    # Run the pipeline step
    ./dummy/dvc/mlvtools_step3_convert_binaries_dvc
    
    # Version files
    git add *.dvc ./dummy/
    git commit -m 'Dummy pipeline step3' 



# Step 4: Convert Octal Values 

This step converts octal values into the corresponding Ascii code. This step is analog to the step 3 but input data are 
octal values not binary values. It is writen as simple it is possible using basics **dvc-in** and **dvc-out** in Docstring.
It is based on `step4_convert_octals.ipynb` notebook.


|||
| :--- | :--- |
| **Step Input**: | `./dummy/data/octal_data.txt` |
|||
| **Step Output**: | `./dummy/data/data_conv_from_octal.txt`|
|||
|**Generated files**:| `./dummy/pipeline/steps/mlvtools_step4_convert_octals.py`|
| | `./dummy/dvc/mlvtools_step4_convert_octals_dvc`|

    # Copy Jupyter Notebook
    cp ./resources/dummy/step4_convert_octals.ipynb ./dummy/pipeline/notebooks/
    
    # Generate Python script and DVC pipeline step
    ipynb_to_python -n ./dummy/pipeline/notebooks/step4_convert_octals.ipynb  
    gen_dvc -i ./dummy/pipeline/steps/mlvtools_step4_convert_octals.py

    # Run the pipeline step
    ./dummy/dvc/mlvtools_step4_convert_octals_dvc
    
    # Version files
    git add *.dvc ./dummy/
    git commit -m 'Dummy pipeline step4' 
    
    

# Step 5: Merge and Sort Data 

This step merge Ascii characters produced by step 3 and 4 and then it sorts them.
It also shows how to use **MLflow** through an "artificial" example.

It is based on `step5_sort_data.ipynb` notebook.


|||
| :--- | :--- |
| **Step Input**: | `./dummy/data/data_conv_from_octal.txt` |
| | `./dummy/data/data_conv_from_bin.txt` |
|||
| **Step Output**: | `./dummy/data/result.txt`|
|||
|**Generated files**:| `./dummy/pipeline/steps/mlvtools_step5_sort_data.py`|
| | `./dummy/dvc/mlvtools_step5_sort_data_dvc`|

    # Copy Jupyter Notebook
    cp ./resources/dummy/step5_sort_data.ipynb ./dummy/pipeline/notebooks/
    
    # Generate Python script and DVC pipeline step
    ipynb_to_python -n ./dummy/pipeline/notebooks/step5_sort_data.ipynb  
    gen_dvc -i ./dummy/pipeline/steps/mlvtools_step5_sort_data.py

    # Run the pipeline step
    ./dummy/dvc/mlvtools_step5_sort_data_dvc
    
    # Version files
    git add *.dvc ./dummy/
    git commit -m 'Dummy pipeline step5' 

This step produces **MLflow** tracking metrics. To visualize them run `mlflow ui --file-store ./dummy/data/mlflow/`
then go to `http://localhost:5000`.

# Check the Result 

The pipeline input is `./dummy/data/dummy_pipeline_feed.txt` and the pipeline result is
`./dummy/data/result.txt`.

You can check the result:

    cat ./dummy/data/result.txt
    
It is also possible to visualize the pipeline structure:

    dvc pipeline show mlvtools_step5_sort_data.dvc
    
    OR 
    
    dvc pipeline show mlvtools_step5_sort_data.dvc --ascii


# Reproduce the Pipeline

### Overview

      #1 --> #2 --> #3 --> #5
               \ 
                --> #4 --/

### Use Cache

If we try to reproduce the pipeline without any change, nothing is computed again because
**DVC** use a cache mechanism.

    
    dvc repro ./mlvtools_step5_sort_data.dvc  -v
    
        Debug: updater is not old enough to check for updates
        Debug: Dvc file 'mlvtools_step1_sanitize_data.dvc' didn't change
        Debug: Dvc file 'mlvtools_step2_split_data.dvc' didn't change
        Debug: Dvc file 'mlvtools_step3_convert_binaries.dvc' didn't change
        Debug: Dvc file 'mlvtools_step4_convert_octals.dvc' didn't change
        Debug: Dvc file 'mlvtools_step5_sort_data.dvc' didn't change
        Pipeline is up to date. Nothing to reproduce.

No step is re-run because nothing has changed.


### Without Cache

It is possible to reproduce the pipeline without cache mechanism.

    dvc repro ./mlvtools_step5_sort_data.dvc -v -f

### Modify Pipeline Input 

If the pipeline input is modified, **DVC** detects there is a change and it reproduces impacted steps.

##### 1.Reproduce the Whole Pipeline

a. Modify input.
    
    make dummy-input2
    
b. Reproduce the whole pipeline.

    dvc repro [Last pipeline step]
    dvc repro ./mlvtools_step5_sort_data.dvc
    
To reproduce the whole pipeline the last pipeline step is provided to **dvc repro** command line.
We can see all steps are run.


c. Check files
    
    git status -s

     M dummy/data/dummy_pipeline_feed.txt.dvc
     M mlvtools_step1_sanitize_data.dvc
     M mlvtools_step2_split_data.dvc
     M mlvtools_step3_convert_binaries.dvc
     M mlvtools_step4_convert_octals.dvc
     M mlvtools_step5_sort_data.dvc

We can see all **DVC** meta files has been modified. And the result file contains a new text.

    cat ./dummy/data/result.txt 
       
       It is easy to reproduce a whole pipeline !

d. Commit the new pipeline version.

    git commit -m "New pipeline version"  *.dvc **/*.dvc
    
e. Remove changes.

   It is possible to use all **git** commands which impact commits (checkout, revert, reset, ...). The 
   only thing to *never forget* is to run **dvc checkout** after that.
   
    git revert HEAD
    dvc checkout 
   
    cat ./dummy/data/result.txt
    
        You reached the end of this dummy pipeline, now we can try to reproduce it!
 

##### 2.Reproduce a Sub-Pipeline

a. Modify input.
    
    make dummy-input3
    
b. Reproduce a sub-pipeline.

    dvc repro [Intermediate pipeline step]
    dvc repro ./mlvtools_step3_convert_binaries.dvc
    
It is possible to run the **dvc repro** command on any pipeline step. 
This can be useful to compute intermediate results. You can see only steps 1, 2 and 3 are run.

c. Complete the pipeline.

    dvc repro ./mlvtools_step5_sort_data.dvc
    
   Only steps 4 and 5 are run because of cache.
   
   
d. Check result then commit.

    cat ./dummy/data/result.txt 
        It is also easy to reproduce a a sub-pipeline \o/ !!!
    
    git commit -m "New pipeline version 2"  *.dvc **/*.dvc


### Modify Pipeline Code

In this example we will modify the code of **Jupyter Notebook**. It is an algorithm change.

1. Algorithm change.

    Open `./dummy/pipeline/notebooks/step4_convert_octals.ipynb`
    
    Create a new cell before the file result write. Add the following code, then save.
    
        str_to_add = " It is an algo change !"
        
        max = int(sorted(characters, key=lambda v: int(v.split('=')[0]))[-1].split('=')[0]) + 1
        
        for char in str_to_add:
            characters.append(f'{max}={char}')
            max += 1
    
    This modification appends a text to the text to convert.

2. Re-generate scripts and commands

        # Generate Python script and DVC pipeline step
        ipynb_to_python -n ./dummy/pipeline/notebooks/step4_convert_octals.ipynb -f
        gen_dvc -i ./dummy/pipeline/steps/mlvtools_step4_convert_octals.py -f

3. Check changes

        git status -s 
    
         M dummy/pipeline/notebooks/step4_convert_octals.ipynb
         M dummy/pipeline/steps/mlvtools_step4_convert_octals.py

    A new Python script has been generated.
    > The DVC command remains the same because no parameter change has been done. 

4. Reproduce pipeline

        dvc repro ./mlvtools_step5_sort_data.dvc 
        
            Pipeline is up to date. Nothing to reproduce.
            
    Nothing happen, it is because **DVC** tracks inputs and outputs, not the code.
    
    Solution:
    
    Run the modified step individually then once everything is ok complete the pipeline.
        
            ./dummy/dvc/mlvtools_step4_convert_octals_dvc
            dvc repro ./mlvtools_step5_sort_data.dvc
      
5. Check the result

       cat ./dummy/data/result.txt 
        
          It is also easy to reproduce a a sub-pipeline \o/ !!! It is an algo change !
 

### Modify Pipeline Hyperparameter

In this example we will change the value of the parameter which describes the number of bits in a binary value.
It is a dummy example to show of to reproduce a pipeline after an hyperparameter change.

Start from initial case:

    git revert HEAD
    dvc checkout        

1. Hyperparameter change

    Parameters are stored in **DVC** commands. Open `./dummy/dvc/mlvtools_step2_split_data_dvc`
     and replace :
     
           --size-bin-data 8
           
        WITH 
        
           --size-bin-data 7
           
    > This change can also be done in the Jupyter Notebook but it must be follow by a script and command re-generation.

2. Check changes
    
      git status -s 
    
       M dummy/dvc/mlvtools_step2_split_data_dvc
       
   The DVC command is modified.
   > The Python script is unchanged as there is no algorithm change.
   
3. Reproduce pipeline

        dvc repro ./mlvtools_step5_sort_data.dvc 
        
            Pipeline is up to date. Nothing to reproduce.
            
    Nothing happen, it is because **DVC** tracks inputs and outputs, not the code.
    
    Solution:
        
        Run the first modified step individually then once everything is ok complete the pipeline.
            
                ./dummy/dvc/mlvtools_step2_split_data_dvc
                dvc repro ./mlvtools_step5_sort_data.dvc

5. Check the result

       cat ./dummy/data/result.txt 
        

You reached the end of this dummy tutorial. A tutorial with more realistic cases is
 available [here](./setup.md).

Or [go back to README](../README.md)



 
