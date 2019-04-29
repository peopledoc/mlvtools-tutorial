DVC Playground
===============

The aim of this tutorial is to understand how [DVC](https://dvc.org/) (Data Version Control) works. It explains how to:

1. Create a pipeline

2. Reproduce a pipeline

3. Setup a data storage

4. Collaborate with your teammates


Requirements
------------
- docker
- docker-compose

Build & Run a Pipeline
----------------------

##### Build and start containers: 
    docker-compose build
    docker-compose up -d
    
Kind of containers:

- **Git** server to host a repository
- **DVC** storage server to remotely store data
- 2 basic **users**

##### See all running servers:

        docker ps
        
<details>
    <summary><i>See containers</i></summary>
  
      
          CONTAINER ID        IMAGE                            COMMAND               CREATED             STATUS              PORTS                NAMES
          340ffc3103f6        dvc_playground_user1             "tail -f /dev/null"   8 seconds ago       Up 5 seconds        22/tcp               dvc_playground_user1_1
          59b4ffba1a1a        dvc_playground_user2             "tail -f /dev/null"   8 seconds ago       Up 6 seconds        22/tcp               dvc_playground_user2_1
          52fc35701408        dvc_playground_remote_dvc_repo   "/usr/sbin/sshd -D"   10 seconds ago      Up 7 seconds        0.0.0.0:22->22/tcp   dvc_playground_remote_dvc_repo_1
          6584ac8c4002        dvc_playground_remote_git_repo   "/usr/sbin/sshd -D"   10 seconds ago      Up 8 seconds                             dvc_playground_remote_git_repo_1

</details>

##### Connect to first user:

        docker-compose exec user1 bash
        cd ~
        
##### Git clone the repository:

        git clone git@git_srv:/srv/git/test_dvc_remote.git
        cd test_dvc_remote/
        
##### Init DVC environment:

        dvc init
        git add .dvc
        git commit -m 'DVC init project'
        
<details>
    <summary><i>More about <b>.dvc</b></i></summary>
    
        .dvc/
        ├── cache/               [ contains hard link for data file versioning]          
        ├── config               [ DVC configuration (ex: remote storage address)]
        └── updater              [ DVC internal version file]        
</details>
        


Build a pipeline
----------------

**Goal**: build a pipeline with 2 steps to visualize a result.

    [parameters.json] **************************************
                                                            **
    [part1.input] **                                          **
                     **    ______________                       ***_________           
                       ** / Concat Files \ ** [file.encrypted] ** / Decrypt \ ** result.txt
                     **   \______________/                        \_________/
    [part2.input] **

<details>
    <summary><i>Details</i></summary>    
<pre>
 Pipeline inputs               Steps                       Intermediate results
 - part1.input     (step1)     - Step1: Concat Files       - file.encrypted  
 - part2.inpt      (step1)     - Step2: Decrypt            - result.txt  
 - parameters.json (step2)
</pre></details>

##### Get input data
        
        mkdir -p data/inputs
        cp /resources/inputs/* ./data/inputs
<details>
    <summary><i>See structure: <b>tree</b></i></summary>
    
    .
    └── data
        └── inputs
            ├── parameters.json
            ├── part1.input
            └── part2.input
</details>

##### Track pipeline inputs under DVC

        dvc add ./data/inputs/part1.input
        dvc add ./data/inputs/part2.input
        dvc add ./data/inputs/parameters.json

        git add data
<details>
    <summary><i>Run <b>git status</b></i></summary>
    
    On branch master
    Your branch is based on 'origin/master', but the upstream is gone.
      (use "git branch --unset-upstream" to fixup)
    Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)
    
        new file:   data/inputs/.gitignore
        new file:   data/inputs/parameters.json.dvc
        new file:   data/inputs/part1.input.dvc
        new file:   data/inputs/part2.input.dvc

</details>

        git commit -m 'Add Pipeline inputs'

###  Step 1: concat files

##### Add **step1** script: concat_files.py

        mkdir steps
        cp /resources/steps/concat_files.py ./steps
        
        git add ./steps/concat_files.py
        git commit -m 'Add pipeline step1: aggregate inputs'
        
<details>
  <summary><i>See structure: <b>tree</b></i></summary>
    
    .
    ├── data
    │   └── inputs
    │       ├── parameters.json
    │       ├── parameters.json.dvc
    │       ├── part1.input
    │       ├── part1.input.dvc
    │       ├── part2.input
    │       └── part2.input.dvc
    └── steps
        └── concat_files.py
    
    3 directories, 5 files
</details>
        
##### Execute **step1** with DVC

        mkdir -p ./data/intermediate/
        
        STEP1_CMD="./steps/concat_files.py -i ./data/inputs/ -o ./data/intermediate/file.encrypted"
        
        dvc run -d ./data/inputs/part1.input \
                -d ./data/inputs/part2.input \
                -o ./data/intermediate/file.encrypted \
                $STEP1_CMD
                
        cat ./data/intermediate/file.encrypted
                
<details>
  <summary><i>Run <b>git status</b></i></summary>
  
    On branch master
    Your branch is ahead of 'origin/master' by 1 commit.
      (use "git push" to publish your local commits)
    Untracked files:
      (use "git add <file>..." to include in what will be committed)
    
    	data/intermediate/
    	file.encrypted.dvc
</details>

A DVC metadata file is created: `./file.encrypted.dvc`
It represents a DVC step.
    
##### Track **step1** DVC execution

        git add ./file.encrypted.dvc ./data/intermediate/
        git commit -m 'Pipeline step 1: executed'
        
        git push origin master
        
###  Step 2: decrypt files

##### Add **step2** script: decrypt.py

        cp /resources/steps/decrypt.py ./steps
        
        git add ./steps/decrypt.py
        git commit -m 'Add pipeline step2: decrypt file'
        
##### Execute **step2** with DVC
        
        STEP2_CMD="./steps/decrypt.py -i ./data/intermediate/file.encrypted \
                    -o ./data/intermediate/result.txt \
                    -p ./data/inputs/parameters.json"
        
        dvc run -d ./data/intermediate/file.encrypted \
                -d ./data/inputs/parameters.json \
                -o ./data/intermediate/result.txt \
                $STEP2_CMD
                
        cat ./data/intermediate/result.txt
                

<details>
  <summary><i>Run <b>git status</b></i></summary>
  
      On branch master
         Your branch is ahead of 'origin/master' by 1 commit.
           (use "git push" to publish your local commits)
         Changes not staged for commit:
           (use "git add <file>..." to update what will be committed)
           (use "git checkout -- <file>..." to discard changes in working directory)
         
            modified:   data/intermediate/.gitignore
         
         Untracked files:
           (use "git add <file>..." to include in what will be committed)
         
            result.txt.dvc
         
         no changes added to commit (use "git add" and/or "git commit -a")
</details>


A DVC metadata file is created: ./result.txt.dvc
It represent a DVC step.


##### Track **step2** DVC execution

        git add ./result.txt.dvc ./data/intermediate/
        git commit -m 'Pipeline step 2: executed'
        
        git push origin master
        
###  See the pipeline


##### Directory structure
    
    tree

<details>
  <summary><i>See structure: <b>tree</b></i></summary>
  
      .
      ├── data
      │   ├── inputs
      │   │   ├── parameters.json      [ real file ]
      │   │   ├── parameters.json.dvc  [ Pipeline input DVC meta file ] 
      │   │   ├── part1.input          [ real file ]
      │   │   ├── part1.input.dvc      [ Pipeline input DVC meta file ] 
      │   │   ├── part2.input          [ real file ]
      │   │   └── part2.input.dvc      [ Pipeline input DVC meta file ]
      │   └── intermediate
      │       ├── file.encrypted       [ real file ]
      │       └── result.txt           [ real file ]
      ├── file.encrypted.dvc           [ DVC meta file ] 
      ├── result.txt.dvc               [ DVC meta file ]
      └── steps
          ├── concat_files.py          [ step 1 ]
          └── decrypt.py               [ step 2 ]
      
      4 directories, 10 files
</details>

##### Visualize the pipeline

    dvc pipeline show ./result.txt.dvc --ascii

Reproduce a pipeline 
---------------------

##### Re-run a pipeline

    dvc repro ./result.txt.dvc
    
Nothing happened because cache mechanism is used and all steps are up to date.
 
##### Re-run a pipeline without cache

    dvc repro ./result.txt.dvc -f
    
All steps are re-run because cache is disabled.
    
##### Re-run a pipeline with changes

- Change `./data/inputs/parameters.json` (step2 input)
- Run `dvc status`


        WARNING: Corrupted cache file .dvc/cache/5d/608d4921754e8305e2ab4fdee53b2c.
        result.txt.dvc:
            changed deps:
                modified:           data/inputs/parameters.json
        data/inputs/parameters.json.dvc:
            changed outs:
                not in cache:       data/inputs/parameters.json

A change is detected on the pipeline input: `data/inputs/parameters.json.dvc` and on the step 2:
`result.txt.dvc` as the impacted input is one of its dependencies.

- Re-add `./data/inputs/parameters.json` as it is a pipeline input
- Run `dvc status`


        WARNING: Corrupted cache file .dvc/cache/5d/608d4921754e8305e2ab4fdee53b2c.
        result.txt.dvc:
            changed deps:
                modified:           data/inputs/parameters.json
There is a remaining change on the step 2: `result.txt.dvc`.
- Run `dvc repro ./result.txt.dvc`
    
    
        Stage 'data/inputs/part1.input.dvc' didn't change.
        Stage 'data/inputs/part2.input.dvc' didn't change.
        Stage 'file.encrypted.dvc' didn't change.
        Stage 'data/inputs/parameters.json.dvc' didn't change.
        WARNING: Dependency 'data/inputs/parameters.json' of 'result.txt.dvc' changed because it is 'modified'.
        WARNING: Stage 'result.txt.dvc' changed.
        Reproducing 'result.txt.dvc'
        Running command:
            ./steps/decrypt.py -i ./data/intermediate/file.encrypted -o ./data/intermediate/result.txt -p ./data/inputs/parameters.json
        Saving 'data/intermediate/result.txt' to cache '.dvc/cache'.
        Saving information to 'result.txt.dvc'.

        To track the changes with git run:

            git add result.txt.dvc

Only the **step2**: decrypt is executed because **step1** remains up to date. `data/inputs/parameters.json` is only a dependency of **step2**.

- See the result `cat ./data/intermediate/result.txt`


##### Revert a change

You are not happy with this change, hopefully you can discard it as easily as running a git checkout.

    
    git checkout .
    dvc checkout 
    
> Don't forget to run a dvc checkout each time you run a git checkout to ensure data tracked with DVC
are always in line with DVC metadata (tracked with GIT).

Use a remote storage
--------------------

##### Where is the data stored?

    tree .dvc/
    
    cat ./result.txt.dvc
    
Data is stored as hard links in `.dvc/cache`. Each version of one data file is identified
with a **md5** hash. This hash correspond to a cache entry and it changes when the data is modified.

By default DVC use a local storage, but it is not really safe, you can remove it, you can easily loose
your development server, ... And you can't share you work with your teammates.

##### Setup a remote storage

A lot of storage options are available using [DVC](https://dvc.org/doc/user-guide/external-outputs): Amazon S3, Google Cloud Storage, ...

In this example we will use an **SSH** DVC server.

        dvc remote add dvc_remote ssh://dvc_user@dvc_srv:/data/dvc/remote
        dvc config core.remote dvc_remote
        git commit -m 'Add DVC remote storage' .dvc/config
        git push origin master
The **remote storage** configuration is tracked using GIT.

##### Push the data
Once the remote storage is set up, it is possible to push the data. 
All the data tracked with DVC is pushed to the **remote ssh storage**.
 
        dvc push

##### Make (then correct) a mistake
Now we can make a mistake and remove the whole repository loosing GIT and DVC parts on **user1** computer.

        cd ..
        rm -rf ./test_dvc_remote/
As all the code, the meta and the configuration files are versioned with GIT it is easy to get them back.        
        
        git clone git@git_srv:/srv/git/test_dvc_remote.git
        cd test_dvc_remote && tree 
Then according to the meta files it is also easy to get the data back from the **remote ssh storage**.

        dvc pull


New teammate
-------------

A new teammate arrived in your team. She has been asked to develop a new feature.

    docker-compose exec user2 bash

###  User2: New feature
 
##### Get the repository   
    cd ~ && git clone git@git_srv:/srv/git/test_dvc_remote.git
    cd test_dvc_remote/ && tree
    
##### Get the data in the last version
    dvc pull
    
##### Create a new feature branch

    git checkout -b apply_happiness
    
##### Add **step3** script: happiness.py

    cp /resources/steps/happiness.py ./steps
            
    git add ./steps/happiness.py
    git commit -m 'Add pipeline step3: apply happiness'

##### Execute **step3** with DVC

    STEP3_CMD="./steps/happiness.py -i ./data/intermediate/result.txt -o ./data/intermediate/happy_result.txt"
            
    dvc run -d ./data/intermediate/result.txt \
            -o ./data/intermediate/happy_result.txt \
            $STEP3_CMD
            
##### Track **step3** DVC execution

    git add ./happy_result.txt.dvc ./data/intermediate/
    git commit -m 'Pipeline step 3: executed'
    
    git push origin apply_happiness
        
##### Push new data
        
    dvc push
    

###  User1: See new pipeline result   

##### Get git branch 

On **user1** environment:

    git fetch origin
    git checkout apply_happiness

Then run `dvc status`:

       happy_result.txt.dvc:
            changed outs:
                not in cache:       data/intermediate/happy_result.txt

A new data file is available.                
##### Get data

    dvc pull
    
##### See the result

    cat ./data/intermediate/happy_result.txt 

 


                       
