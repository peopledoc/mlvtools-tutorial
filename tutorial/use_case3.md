# Use Case 3: Reuse Pipeline Step

The aim of this use case is to show how to create a new pipeline which re-use steps (intermediate results) from an other
pipeline.

**Requirements**: 

- setup the environment ([tutorial setup](./setup.md))
- build the pipeline from [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md)

> Note: it is possible to quickly build the pipeline from Use Case 1 running `make setup` if setup is not done
then `make pipeline1`. Be careful, the pipeline files and DVC meta files will not be committed.
                  

We want to reuse the beginning of the **Use Case 1** pipeline to test if results are better with an other classifier. 

    `20news-bydate_py3.pkz` = Split => `data_train.csv` = Tokenize => `data_train_tokenized.csv` = *NEW_CLASSIFIER* => `fasttext_model_bis.bin` = Evaluate => *`metrics_bis.txt`*
                                                                                                                                       \\                           
                                        `data_test.csv`  = Tokenize => `data_test_tokenized.csv`  =================================== + \ = Evaluate => *`metrics_test_bis.txt`* 

   
We don't want to create a new version of the pipeline
 (as it is done in [Use Case 2: Create a new version of a pipeline](./use_case2.md)), but we want to create a new 
 pipeline based on steps of the pipeline from [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md).
     

## 1. Create the New Classifier Scripts and Commands in a New Pipeline


This pipeline step is based on the `03_bis_Classify_text.ipynb` **Jupyter notebook**. The idea is the same as with use case 2, 
we want to improve our plain neural network by using trigrams instead of unigrams as inputs. Contrary to the previous use case though, 
we want to reuse tokenized data and overwrite the previous pipeline.


> Input file will remain the same as this pipeline base is a step of the pipeline from Use Case 1
> Output files must have different names

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_train_tokenized.csv` |
|||
| **Step Outputs**: | `./poc/data/fasttext_model_bis.bin`|
| | `./poc/data/fasttext_model_bis.vec`
|||
|**Generated files**:| `./poc/pipeline/steps/mlvtools_03_bis_classify_text.py`|
| | `./poc/commands/dvc/mlvtools_03_bis_classify_text_dvc`|

1. Copy the `03_bis_Classify_text.ipynb` from the resources directory to the *poc* project:

        cp ./resources/03_bis_Classify_text.ipynb ./poc/pipeline/notebooks/
    
2. Edit the notebook with right paths `./poc/pipeline/notebooks/03_bis_Classify_text.ipynb`
   (see input/outputs above)
   
   The Docstring must be :
   
       """
        :param str input_csv_file: Path to input file
        :param str out_model_path: Path to model files
        :param float learning_rate: Learning rate
        :param int epochs: Number of epochs
        
        :dvc-in input_csv_file: ./poc/data/data_train_tokenized.csv
        :dvc-out out_model_path: ./poc/data/fasttext_model_bis.bin
        :dvc-out: ./poc/data/fasttext_model_bis.vec
        :dvc-extra: --learning-rate 0.7 --epochs 4
       """
    
 3. Continue with usual process
 
 
        # Git versioning
        git add ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb
        git commit -m 'Tutorial: use case 3 step 1 - Add notebook'
        
        # Convert to Python script
        ipynb_to_python -w . -n ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb
        
        # Generate command
        gen_dvc -w . -i ./poc/pipeline/steps/mlvtools_03_bis_classify_text.py
        
        # Run 
        ./poc/commands/dvc/mlvtools_03_bis_classify_text_dvc
        
        # Version the result
        git add *.dvc && git add ./poc/pipeline ./poc/commands/ ./poc/data/
        git commit -m 'Tutorial use case 3 step 1: classify text'
    
    
## 2. Run Model Evaluation From New Classifier

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_train_tokenized.csv` |
| | `./poc/data/fasttext_model_bis.bin`|
|||
| **Step Output**: | `./poc/data/metrics_bis.txt`|
|||
|**New file**:| `./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc`| 
 
The **Jupyter notebook** involved it this step is `04_Evaluate_model.ipynb`. We have already generated the corresponding 
script in [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md).
We only need to run this step with different **inputs** and **outputs**.
To do that we will create a new **DVC** command file with new inputs/outputs.

    # Copy DVC command file
    cp ./poc/commands/dvc/mlvtools_04_evaluate_model_dvc ./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc
    
    
Edit `./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc`

    Replace :
        MODEL_FILE="./poc/data/fasttext_model.bin"
        RESULT_FILE="./poc/data/metrics.txt"
    with :
        MODEL_FILE="./poc/data/fasttext_model_bis.bin"
        RESULT_FILE="./poc/data/metrics_bis.txt"
        
Edit the **DVC meta file** variable. It is a very important step. If 2 **DVC**  steps have the same name they will 
overwrite their meta file and break their pipeline.

    Replace :
            MLV_DVC_META_FILENAME="mlvtools_04_evaluate_model.dvc"
        with :
            MLV_DVC_META_FILENAME="mlvtools_04_bis_evaluate_model.dvc"
        
Save the file.


Run new **DVC** pipeline step.

    ./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc

    
Commit this step.

    git add *.dvc && git add ./poc/commands/dvc
    git commit -m 'Tutorial use case 1 step 6: evaluate model on test data'


## 3. Run Model Evaluation From New Classifier on Test Dataset

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_test_tokenized.csv` |
| | `./poc/data/fasttext_model_bis.bin`|
|||
| **Step Output**: | `./poc/data/metrics_test_bis.txt`|
|||
|**New file**:| `./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc`| 
 
The **Jupyter notebook** involved it this step is `04_Evaluate_model.ipynb`. We have already generated the corresponding 
script in [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md).
We only need to run this step with different **inputs** and **outputs**.
To do that we will create a new **DVC** command file with new inputs/outputs.

    # Copy DVC command file
    cp ./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc ./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc
    
    
Edit `./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc`

    Replace :
        MODEL_FILE="./poc/data/fasttext_model.bin"
        RESULT_FILE="./poc/data/metrics_test.txt"
    with :
        MODEL_FILE="./poc/data/fasttext_model_bis.bin"
        RESULT_FILE="./poc/data/metrics_test_bis.txt"
        
Edit the **DVC meta file** variable. It is a very important step. If 2 **DVC**  steps have the same name they will 
overwrite their meta file and break their pipeline.

    Replace :
            MLV_DVC_META_FILENAME="mlvtools_04_evaluate_test_model.dvc"
        with :
            MLV_DVC_META_FILENAME="mlvtools_04_bis_evaluate_test_model.dvc"
        
Save the file.

Run new **DVC** pipeline step.

    ./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc

    
Commit this step.

    git add *.dvc && git add ./poc/commands/dvc
    git commit -m 'Tutorial use case 1 step 6: evaluate model on test data'
        
    
## 4. Check Result

All step of the pipeline are run. We can compare metrics obtained in `./poc/data/metrics_bis.txt` and
`./poc/data/metrics_test_bis.txt`

We can run an ultimate step to print the result of the pipeline.

    dvc run -f PipelineUseCase2.dvc -d ./poc/data/metrics_bis.txt -d ./poc/data/metrics_test_bis.txt \
        cat ./poc/data/metrics_bis.txt ./poc/data/metrics_test_bis.txt 
    
## 5. Show and Reproduce the pipeline

It is possible to see each step of both pipelines. 

    dvc pipeline show PipelineUseCase2.dvc          dvc pipeline show PipelineUseCase1.dvc
    
    > poc/data/20news-bydate_py3.pkz.dvc ********   > poc/data/20news-bydate_py3.pkz.dvc
    > mlvtools_01_extract_dataset.dvc    ********   > mlvtools_01_extract_dataset.dvc
    > mlvtools_02_tokenize_text.dvc      ********   > mlvtools_02_tokenize_text.dvc
    > mlvtools_03_bis_classify_text.dvc             > mlvtools_03_classify_text.dvc
    > mlvtools_04_bis_evaluate_model.dvc            > mlvtools_04_evaluate_model.dvc
    > mlvtools_02_test_tokenize_text.dvc ********   > mlvtools_02_test_tokenize_text.dvc 
    > mlvtools_04_bis_evaluate_test_model.dvc       > mlvtools_04_evaluate_test_model.dvc
    > PipelineUseCase2.dvc                          > PipelineUseCase1.dvc
    
 We can see first steps are the same, they are shared between both pipelines.
 
It is possible to reproduce the pipeline.

    dvc repro PipelineUseCase2.dvc -v
    
With no input change, the cache should be used. Output:
    
    Debug: updater is not old enough to check for updates
    Debug: Dvc file 'poc/data/20news-bydate_py3.pkz.dvc' didn't change
    Debug: Dvc file 'data_train.csv.dvc' didn't change
    Debug: Dvc file 'data_train_tokenized.csv.dvc' didn't change
    Debug: Dvc file 'fasttext_model_bis.vec.dvc' didn't change
    Debug: Dvc file 'metrics_bis.txt.dvc' didn't change
    Debug: Dvc file 'data_test_tokenized.csv.dvc' didn't change
    Debug: Dvc file 'metrics_test_bis.txt.dvc' didn't change
    Debug: Dvc file 'PipelineUseCase2.dvc' didn't change
    Pipeline is up to date. Nothing to reproduce.

    
If we change input data, the pipeline is re-run.

    make change-input-data
    
    dvc repro ./PipelineUseCase2.dvc -v
    
    git commit -m 'Tutorial use case 3: repro with shuffled data' *.dvc **/*.dvc
   
 
You reached the end of this tutorial, see [Use Case 4: Combine Metrics](./use_case4.md)
 
 Or [go back to README](../README.md)
