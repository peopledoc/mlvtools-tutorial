# Use Case 1: Build and Reproduce a Pipeline

The aim of this use case is to show how to build a pipeline and how to reproduce it.

**Requirements**: setup the environment ([tutorial setup](./setup.md))

**Pipeline Overview**

    `20news-bydate_py3.pkz` = Split => `data_train.csv` = Tokenize => `data_train_tokenized.csv` = Classify => `fasttext_model.bin` = Evaluate => `metrics.txt`
                                                                                                                                   \\
                                         `data_test.csv`  = Tokenize => `data_test_tokenized.csv`  ============================== + \ = Evaluate => `metrics_test.txt`


## 1. Split Dataset

This pipeline step is based on the `01_Extract_dataset.ipynb` **Jupyter notebook**. It loads
 data downloaded in setup and splits them into a train or a test data set.

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/20news-bydate_py3.pkz` |
|||
| **Step Output**: | `./poc/data/data_train.csv`|
| | `./poc/data/data_test.csv`|
|||
|**Generated files**:| `./poc/pipeline/steps/mlvtools_01_extract_dataset.py`|
| | `./poc/commands/dvc/mlvtools_01_extract_dataset_dvc`|

1. Add the pipeline input file under **DVC** versioning

        dvc add ./poc/data/20news-bydate_py3.pkz

2. Copy the `01_Extract_dataset.ipynb` from the resources directory to the poc project:

        cp ./resources/01_Extract_dataset.ipynb ./poc/pipeline/notebooks/

3. Open the notebook, read info about parameters and try it.

4. Commit it.

       git add ./poc/pipeline/notebooks/01_Extract_dataset.ipynb **/*.dvc

       git commit -m 'Tutorial: use case 1 step 1 - Add notebook'

5. Convert the **Jupyter notebook** into a parameterized **Python script** using `ipynb_to_python`

       ipynb_to_python -w . -n ./poc/pipeline/notebooks/01_Extract_dataset.ipynb

   Ensure `./poc/pipeline/steps/mlvtools_01_extract_dataset.py` is well created.

6. Create a **DVC** command to run the **Python** script using **DVC**

       gen_dvc -w . -i ./poc/pipeline/steps/mlvtools_01_extract_dataset.py

   Ensure `./poc/commands/dvc/mlvtools_01_extract_dataset_dvc` is created

7. Run the *DVC* command

       ./poc/commands/dvc/mlvtools_01_extract_dataset_dvc

8. If you are satisfied with the result, track scripts and DVC meta files

        git add *.dvc ./poc
        git commit -m 'Tutorial use case 1 step 1: split dataset'

> If you are not satisfied with the result, do not edit generated script. Edit the **Jupyter notebook** which is the reference
then re-run ipynb_to_python and gen_dvc.


## 2. Tokenize Text

The next step in the pipeline (see `02_Tokenize_text.ipynb` **Jupyter notebook**) is to tokenize
the text input, as is usual in Natural Language Processing. In order to do that, we use the wordpunkt
 tokenizer provided by NLTK.

We also remove English stopwords (frequent words who add no semantic meaning, such as "and", "is",
"the"...).

Each token is also converted to lower-case and non-alphabetic tokens are removed.

In this very simple tutorial example, we do not apply any lemmatization technique.

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_train.csv` |
|||
| **Step Output**: | `./poc/data/data_train_tokenized.csv`|
|||
|**Generated files**:| `./poc/pipeline/steps/mlvtools_02_tokenize_text.py`|
| | `./poc/commands/dvc/mlvtools_02_tokenize_text_dvc`|


    # Copy resource to project pipeline directory
    # and then open the notebook, read info about parameters and try it.
    cp ./resources/02_Tokenize_text.ipynb ./poc/pipeline/notebooks/

    # Git versioning
    git add ./poc/pipeline/notebooks/02_Tokenize_text.ipynb
    git commit -m 'Tutorial: use case 1 step 2 - Add notebook'

    # Convert to Python script
    ipynb_to_python -w . -n ./poc/pipeline/notebooks/02_Tokenize_text.ipynb

    # Generate command
    gen_dvc -w . -i ./poc/pipeline/steps/mlvtools_02_tokenize_text.py

    # Run pipeline ./poc/commands/ ./poc/data/
    git commit -m 'Tutorial use case 1 step 2: tokenize text'

    ./poc/commands/dvc/mlvtools_02_tokenize_text_dvc

    # Version the result
    git add *.dvc ./poc
    git commit -m 'Tutorial use case 1 step 2: tokenize text'


## 3. Classify Text
In the `03_Classify_text.ipynb` **Jupyter notebook**, we are going to train a classifier on the tokenized text input,
using the [FastText libary](https://fasttext.cc/).

In addition to the input data file, we give to the command a few hyperparameter values,
and we store the binary file representing the learned model as output.

We only learn for a few epochs, because the purpose is to see how the versioning tools work,
and not train the best classifier possible.

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_train_tokenized.csv` |
|||
| **Step Output**: | `./poc/data/fasttext_model.bin`|
| | `./poc/data/fasttext_model.vec`
|||
|**Generated files**:| `./poc/pipeline/steps/mlvtools_03_classify_text.py`|
| | `./poc/commands/dvc/mlvtools_03_classify_text_dvc`|

    # Copy resource to project pipeline directory
    cp ./resources/03_Classify_text.ipynb ./poc/pipeline/notebooks/

    # Git versioning
    git add ./poc/pipeline/notebooks/03_Classify_text.ipynb
    git commit -m 'Tutorial: use case 1 step 3 - Add notebook'

    # Convert to Python script
    ipynb_to_python -w . -n ./poc/pipeline/notebooks/03_Classify_text.ipynb

    # Generate command
    gen_dvc -w . -i ./poc/pipeline/steps/mlvtools_03_classify_text.py

    # Run
    ./poc/commands/dvc/mlvtools_03_classify_text_dvc

    # Version the result
    git add *.dvc ./poc
    git commit -m 'Tutorial use case 1 step 3: classify text'

## 4. Evaluate the Model
Next, in the **Jupyter notebook** `04_Evaluate_model.ipynb` , we want to evaluate how well the model is doing,
 first on training data.

 |||
 | :--- | :--- |
 | **Step Input**: | `./poc/data/data_train_tokenized.csv` |
 | | `./poc/data/fasttext_model.bin` |
 |||
 | **Step Output**: | `./poc/data/metrics.txt`|
 |||
 |**Generated files**:| `./poc/pipeline/steps/mlvtools_04_evaluate_model.py`|
 | | `./poc/commands/dvc/mlvtools_04_evaluate_model_dvc`|


    # Copy resource to project pipeline directory
    cp ./resources/04_Evaluate_model.ipynb ./poc/pipeline/notebooks/

    # Git versioning
    git add ./poc/pipeline/notebooks/04_Evaluate_model.ipynb
    git commit -m 'Tutorial: use case 1 step 4 - Add notebook'

    # Convert to Python script
    ipynb_to_python -w . -n ./poc/pipeline/notebooks/04_Evaluate_model.ipynb

    # Generate command
    gen_dvc -w . -i ./poc/pipeline/steps/mlvtools_04_evaluate_model.py

    # Run
    ./poc/commands/dvc/mlvtools_04_evaluate_model_dvc

    # Version the result
    git add *.dvc ./poc
    git commit -m 'Tutorial use case 1 step 4: evaluate model on train data'


Check the result:

    cat ./poc/data/metrics.txt

## Checkpoint

Once this step is reached, half of the pipeline is created. For each **Jupyter notebook** we have the
corresponding **Python** script and the **DVC** command.

**Python** executable scripts are "generic", that means they can be applied to any inputs.

Next steps for this pipeline is to run the tokenization and the evaluation steps (notebooks `02_Tokenize_text.ipynb`
and `04_Evaluate_model.ipynb`) on the **test dataset** (`./poc/data/data_test.csv`).

## 5. Run Tokenize Text on Test Dataset

The **Jupyter notebook** involved in this step is `02_Tokenize_text.ipynb`. We have already generated the corresponding script.
We only need to run this step with different **inputs** and **outputs**.
To do that we will create a new **DVC** command file with new inputs/outputs.

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_test.csv` |
|||
| **Step Output**: | `./poc/data/data_test_tokenized.csv`|
|||
|**New file**:| `./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc`|


    # Copy DVC command file
    cp ./poc/commands/dvc/mlvtools_02_tokenize_text_dvc ./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc


Edit `./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc`

    Replace :
        INPUT_CSV_FILE="./poc/data/data_train.csv"
        OUTPUT_CSV_FILE="./poc/data/data_train_tokenized.csv"
    with :
        INPUT_CSV_FILE="./poc/data/data_test.csv"
        OUTPUT_CSV_FILE="./poc/data/data_test_tokenized.csv"

In the same file, update the **DVC meta file** variable. It is a very important step. If 2 **DVC**  steps
have the same name, they will overwrite their meta file and break their pipeline.

    Replace :
            MLV_DVC_META_FILENAME="mlvtools_02_tokenize_text.dvc"
        with :
            MLV_DVC_META_FILENAME="mlvtools_02_test_tokenize_text.dvc"


Save the file.

Run new **DVC** pipeline step.

    ./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc

Check **DVC meta file** is created (it is used by **DVC** to track inputs and outputs of this pipeline step).

    ./mlvtools_02_test_tokenize_text.dvc

Commit this step.

    git add *.dvc ./poc
    git commit -m 'Tutorial use case 1 step 5: tokenize test dataset text'

## 6. Run Model Evaluation on Test Dataset

|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_test_tokenized.csv` |
| | `./poc/data/fasttext_model.bin`|
|||
| **Step Output**: | `./poc/data/metrics_test.txt`|
|||
|**New file**:| `./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc`|

The notebook involved it this step is `04_Evaluate_model.ipynb`. We have already generated the corresponding script.
We only need to run this step with different **inputs** and **outputs**.
To do that we will create a new **DVC** command file with new inputs/outputs.

    # Copy DVC command file
    cp ./poc/commands/dvc/mlvtools_04_evaluate_model_dvc ./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc


Edit `./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc`

    Replace :
        DATA_FILE="./poc/data/data_train_tokenized.csv"
        MODEL_FILE="./poc/data/fasttext_model.bin"
        RESULT_FILE="./poc/data/metrics.txt"
    with :
        DATA_FILE="./poc/data/data_test_tokenized.csv"
        MODEL_FILE="./poc/data/fasttext_model.bin"
        RESULT_FILE="./poc/data/metrics_test.txt"

Edit the **DVC meta file** variable. It is a very important step. If 2 **DVC**  steps have the same name they will
overwrite their meta file and break their pipeline.

    Replace :
            MLV_DVC_META_FILENAME="mlvtools_04_evaluate_model.dvc"
        with :
            MLV_DVC_META_FILENAME="mlvtools_04_evaluate_test_model.dvc"

Save the file.

Run new **DVC** pipeline step.

    ./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc

Check **DVC meta file** is created (it is used by **DVC** to track inputs and outputs of this pipeline step).

    ./mlvtools_04_evaluate_test_model.dvc

Commit this step.

    git add *.dvc ./poc
    git commit -m 'Tutorial use case 1 step 6: evaluate model on test data'

## 7. Check Result

All steps of the pipeline are run. We can compare metrics obtained in `./poc/data/metrics.txt` and
`./poc/data/metrics_test.txt`

We can run an ultimate step to print the result of the pipeline.

    dvc run -f PipelineUseCase1.dvc -d ./poc/data/metrics.txt -d ./poc/data/metrics_test.txt \
        cat ./poc/data/metrics.txt ./poc/data/metrics_test.txt

    git add *.dvc
    git commit -m "Tutorial use case 1 step 7: end of pipeline"

## 8 Reproduce the Pipeline

Once all those steps are run, the pipeline is complete. It is possible to reproduce it using:

    dvc repro [pipeline file identifier] -v

The **pipeline file identifier** is the **DVC** meta file generated by the last step of the pipeline.
Here it is `PipelineUseCase1.dvc`.

    dvc repro PipelineUseCase1.dvc -v


You should obtain :

    Debug: updater is not old enough to check for updates
    Debug: Dvc file 'poc/data/20news-bydate_py3.pkz.dvc' didn't change
    Debug: Dvc file 'mlvtools_01_extract_dataset.dvc' didn't change
    Debug: Dvc file 'mlvtools_02_tokenize_text.dvc' didn't change
    Debug: Dvc file 'mlvtools_03_classify_text.dvc' didn't change
    Debug: Dvc file 'mlvtools_04_evaluate_model.dvc' didn't change
    Debug: Dvc file 'mlvtools_02_test_tokenize_text.dvc' didn't change
    Debug: Dvc file 'mlvtools_04_evaluate_test_model.dvc' didn't change
    Debug: Dvc file 'PipelineUseCase1.dvc' didn't change
    Pipeline is up to date. Nothing to reproduce.


As nothing has changed in input/outputs the pipeline is not re-run, the cache is used.

If we change input data the pipeline will be re-run.

    make change-input-data

    dvc repro ./PipelineUseCase1.dvc -v

The complete pipeline is run on new data:

    Debug: updater is not old enough to check for updates
    Debug: Saving info about '/home/sbracaloni/sandbox/dev/peopledoc/ml-poc-version/.dvc/cache/31/9586a10af45dcec57cb01386a2cb99' to state file.
    Warning: Corrupted cache file .dvc/cache/31/9586a10af45dcec57cb01386a2cb99
    Debug: Removing '.dvc/cache/31/9586a10af45dcec57cb01386a2cb99'
    Debug: Dvc file 'poc/data/20news-bydate_py3.pkz.dvc' changed
    Reproducing 'poc/data/20news-bydate_py3.pkz.dvc'
    Verifying data sources in 'poc/data/20news-bydate_py3.pkz.dvc'
    Saving 'poc/data/20news-bydate_py3.pkz' to cache '.dvc/cache'.
    Debug: Cache type 'reflink' is not supported: EOPNOTSUPP
    Created 'hardlink': .dvc/cache/e7/f2e115ff18407a87f8a1a29f62881f -> poc/data/20news-bydate_py3.pkz
    Debug: 'poc/data/20news-bydate_py3.pkz.dvc' was reproduced
    Saving information to 'poc/data/20news-bydate_py3.pkz.dvc'.
    Debug: Dvc file 'mlvtools_01_extract_dataset.dvc' changed
    Debug: Removing 'poc/data/data_train.csv'
    Debug: Removing 'poc/data/data_test.csv'
    Reproducing 'mlvtools_01_extract_dataset.dvc'
    Running command:
    	poc/pipeline/steps/mlvtools_01_extract_dataset.py --subset train      [...]
    [...]

See changes:

    git status -s

     M mlvtools_01_extract_dataset.dvc
     M mlvtools_02_test_tokenize_text.dvc
     M mlvtools_02_tokenize_text.dvc
     M mlvtools_03_classify_text.dvc
     M mlvtools_04_evaluate_model.dvc
     M mlvtools_04_evaluate_test_model.dvc
     M poc/data/20news-bydate_py3.pkz.dvc

Commit changes:

    git commit -m 'Tutorial use case 1: repro with shuffled data' *.dvc **/*.dvc


 > It is possible to see pipeline steps running `dvc pipeline show ./PipelineUseCase1.dvc`

 You reached the end of this tutorial part, see [Use Case 2: Create a new version of a pipeline](./use_case2.md)

 Or [go back to README](../README.md)
