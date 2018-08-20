# POC versioning Machine Learning pipeline

Exploration of a text classification task on 20newsgroup dataset

The use-cases to consider are the following:
- Hyperparameter optimisation and fine-tuning (saving results)
- Versioning and storage of intermediate (preprocessed) datasets; partial execution of the pipeline starting from precomputed data
- Reproduce a pipeline / experience on new data

Proposed test pipeline:
1. 
    a. Raw text -> tokenizing and cleaning -> clean_data_1 (Preprocessing 1)
    
    b. Raw text -> tokeninzing and lemmatisation and cleaning -> clean_data_2 (Preprocessing 2)
2. 
    a. Clean data -> Bag-of-word (hyperparameter: vocabulary size) -> encoded data
    
    b. Clean data -> Word Embedding -> encoded data
    
    c. Clean data -> fastText -> labels
3. 
    a. Encoded data -> Random Forests (hyperparameters: a lot) -> labels
    
    b. Logisitic Regression -> labels
    
    c. Latent Dirichlet Allocation -> labels
   

## Loading data
   
*Input:* 20newsgroup folder (in `./data/20_newsgroup`)
*Output:* train and test csv files (`./data/data_train.csv` and `./data/data_test.csv`)

1. Write first step (data loading) in a notebook
2. Export to .py script (for now using Jupyter export function; TODO get a better solution)
3. Modify script by hand to get out the parameters (TODO: clean this dirty hack)
4. Initialize git and DVC repo
5. Version empty notebook and hand-written script
6. Run DVC on script to version data results
