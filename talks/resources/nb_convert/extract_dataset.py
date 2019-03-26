#!/usr/bin/env python
# coding: utf-8

# # Extract train and test data set from 20newsgroups

# In[ ]:


subset = 'train'
data_in = '../../data/'
output_path = '../../data/data_train.csv'


# In[ ]:


import pandas as pd
from sklearn.datasets import fetch_20newsgroups


# In[ ]:


nws_train = fetch_20newsgroups(subset=subset,
                               data_home=data_in)


# In[ ]:


# No effect
nws_train.keys()


# In[ ]:


df_train = pd.DataFrame(nws_train.data, columns=['data'])
df_train['target'] = nws_train.target
df_train['targetnames'] = df_train['target'].apply(lambda n: nws_train.target_names[n])


# In[ ]:


# No effect
df_train.head()


# In[ ]:


df_train.to_csv(output_path, index=None)

