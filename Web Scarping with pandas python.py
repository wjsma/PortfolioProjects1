#!/usr/bin/env python
# coding: utf-8

# # Scraping data from a read website + Pandas

# In[2]:


from bs4 import BeautifulSoup
import requests


# In[3]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')


# In[4]:


print(soup)


# In[5]:


soup.find('table')


# In[7]:


soup.find_all('table')[1]


# In[8]:


soup.find('table', class_='wikitable sortable')


# In[31]:


table= soup.find_all('table')[1]


# In[32]:


print(table)


# In[33]:


table.find_all('th')


# In[35]:


world_titles= table.find_all('th')


# In[36]:


world_titles


# In[37]:


world_table_titles= [title.text.strip() for title in world_titles]

print(world_table_titles)


# In[38]:


world_table_titles


# In[39]:


import pandas as pd


# In[41]:


df = pd.DataFrame(columns= world_table_titles)
df


# In[42]:


table.find_all('tr')


# In[45]:


column_data = table.find_all('tr')


# In[49]:


for row in column_data:
    row_data= row.find_all('td')
    individual_row_data =[data.text.strip() for data in row_data]
    print(individual_row_data)


# In[55]:


for row in column_data[1:]:
    row_data= row.find_all('td')
    individual_row_data =[data.text.strip() for data in row_data]
    print(individual_row_data) 
    
    length = len(df)
    df.loc[length] = individual_row_data


# In[56]:


df


# In[62]:


df.to_csv(r'C:\Users\samee\OneDrive\Desktop\Python Web Scraping doc\companies.csv', index = False)


# In[ ]:




