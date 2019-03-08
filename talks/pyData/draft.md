Axé la conf sur l'opposition des mondes surtout vers le debut. et rsultat on se rassemble à la fin.

Overview:

- Presentation
    - Sarah : [petit resumé] + Accroche sur les technos => J'utilise des jupyter notebook
    et j'ai besoin de ...pouvoir reproduire facilement, garder de la souplesse, ...
    
    - Stephanie: [petit résumé] + Accroche Automatisation, Livaison, Tests
       J'ai besoin de... un truc qui se lance facilement, qui se package, qui soit reproductible
       sur n'importe quel environnement
       
       
- Why => Notre histoire: en gros un titre stylé pour dire le portage du 
poc (multi jupyter executables sur 1 machine) vers la prod (enfin au moins le step d'"industrialisation" du projet)
en mixant monde dev et data scientist

  - long et sinueu chemin du poc vers la prod ... à la  croisée des deux mondes
  
  - POC vs PROD ... vs Data scientist vs Software Developer
  

- The POC:

    - set of notebooks, some data, name versioning, specific server/user
    [Show a repo overview]

- Step 1: express our needs

    - Automation/Scripting (first step)
        
            ML side : keep using jupyter notebook
            Dev side: be able to easily run the tool and version a standardized format under git
                      tests, CI

    - Reproducibility/Pipelining/Versioning
    
        => Going further in the automation process
        => No loss, be more confident 
        => Easily perform experiments
        => Handle data sharing 
        
        
        ML side: be able to experiment, avoid to reproduce time consuming steps, keep tracking data
        share with the team. organistation (no more inconstent reference on name versioned notebooks and execution order
        and dependencies)
        
        
        Dev side: be able to reproduce any configuration (data + hyperparam + code) on any server
        keep tracking the state of the art pipeline for further delivery. be ble to handle client specificities
   
   
[Schema représentant besoins]     
        
- Step 2: Organisation start: we need python scripts from jupyter notebooks

    - Existing solutions:  nb convert
    
    - Issues: not parametrized and no effect cells
    
    - MLV-tools: ipynb_to_python
    
    
- Step 3: We need to handle data versioning and pipelining

    - Existing solution: git lfs => data ok, pipelining nok
    - Existing solution: dvc => data ok, pipelining ok BUT... [ not easy to use and based on bash cmd
    mais bonne nouvelle on a deja des scripts]
        - example DVC
        - montrer pkoi c'est relou
        
    - MLV-tools: from jupyter notebook to a pipeline step
    
    
    
- REX

    => souplesse expérimentation commerzbank
    => perte de données
    

        
    
    

    