# Use Case 4: Combine Metrics

One typical use-case in Machine Learning is that of hyper-parameters optimization. We want to train a classifier with various choices 
of hyperparameters, using cross-validation to get an accurate estimate of generalisation metrics (accuracy on validation set, but
also possibly F1-scores or other metrics depending on your data). 

Each of those runs will thus generate a set of metrics, and we want to have a unified view on all results to make a decision on 
the best set of hyperparameters. We use **MLFlow tracking API** to record and expose results.

**Requirements**: 

- setup the environment ([tutorial setup](./setup.md))
- build the pipeline from [Use Case 1: Build and Reproduce a Pipeline](./use_case1.md)

> Note: it is possible to quickly build the pipeline from Use Case 1 running `make setup` if setup is not done
then `make pipeline1`. Be careful, the pipeline files and DVC meta files will not be committed.
                  
We want to reuse the split step from the **Use Case 1** pipeline, and then run cross validation to tune hyperparameters.

    `20news-bydate_py3.pkz` = Split => `data_train.csv` = Classif with Cross Validation => ./poc/data/cross_valid_metrics                           

## 1. Create a Cross Validation Step


This pipeline step is based on the `05_Tune_hyperparameters_with_crossvalidation.ipynb` **Jupyter Notebook**.

We use scikit-learn to build a simple pipeline with two hyperparameters: the number of words in the vocabulary for 
the bag-of-words encoding, and the regularization parameter for the Logistic Regression classifier. 

For tutorial purpose, we try out a very limited number of values (a more realistic scenario would probably involve
a grid search). In order for the step to execute quite quickly, we only use one repetition of 3-fold cross-validation.
Once again, in real life, you'll probably want to use 10 repetitions of 5-fold or 10-fold cross-validation.

In this notebook, the output is just the folder containing all metrics results, but you might also want to store
the model trained with the best hyperparameters. That's a nice exercice for you to try !



|||
| :--- | :--- |
| **Step Input**: | `./poc/data/data_train.csv` |
|||
| **Step Outputs**: | `./poc/data/cross_valid_metrics` |
|||
|**Generated files**:| `./poc/pipeline/steps/mlvtools_05_tune_hyperparameters_with_crossvalidation.py`|
| | `./poc/commands/dvc/mlvtools_05_tune_hyperparameters_with_crossvalidation_dvc`|

1. Copy the `05_Tune_hyperparameters_with_crossvalidation.ipynb` from the resources directory to the poc project:

        cp ./resources/05_Tune_hyperparameters_with_crossvalidation.ipynb ./poc/pipeline/notebooks/
    
2. Continue with usual process
 
 
        # Git versioning
        git add ./poc/pipeline/notebooks/05_Tune_hyperparameters_with_crossvalidation.ipynb
        git commit -m 'Tutorial: use case 4 step 1 - Add notebook'
        
        # Convert to Python 3 script
        ipynb_to_python -n ./poc/pipeline/notebooks/05_Tune_hyperparameters_with_crossvalidation.ipynb
        
        # Generate command
        gen_dvc -i ./poc/pipeline/steps/mlvtools_05_tune_hyperparameters_with_crossvalidation.py
        
        # Run 
        ./poc/commands/dvc/mlvtools_05_tune_hyperparameters_with_crossvalidation_dvc
                
        # Version the result
        git add *.dvc && git add ./poc/pipeline ./poc/commands/ ./poc/data/
        git commit -m 'Tutorial use case 4 step 1: cross validation'
    
 
3. Analyse results

All metrics are logged in **MLflow tracking**. It is possible to visualize them.
 
 Run: `mlflow ui --file-store ./poc/data/cross_valid_metrics/`
 
 Go to: [http://127.0.0.1:5000](http://127.0.0.1:5000)  
 
 
You reached the end of this tutorial.
 
 Or [go back to README](../README.md)