#!/usr/bin/env python
# coding: utf-8

# # Scraping apec webpage (www.apec.fr) with SELENIUM

# ### Web crawling Vs. Web scraping
# - __Web crawling__, also known as Indexing is used to index the information on the page using bots also known as crawlers. Crawling is essentially what search engines do. It’s all about viewing a page as a whole and indexing it. When a bot crawls a website, it goes through every page and every link, until the last line of the website, looking for ANY information. Web Crawlers are basically used by major search engines like Google, Bing, Yahoo, statistical agencies, and large online aggregators.
# 
# - __Web scraping__, also known as web data extraction, is similar to web crawling in that it identifies and locates the target data from web pages. __The key difference, is that with web scraping, we know the exact data set identifier__ e.g. an HTML element structure for web pages that are being fixed, from which data needs to be extracted. Web scraping is an automated way of extracting specific data sets using bots which are also known as ‘scrapers’. Once the desired information is collected it can be used for comparison, verification, and analysis based on a given business’s needs and goals.

# In[1]:


# importing modules:
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from time import time, sleep
import pandas as pd


# In[2]:


# Creating the the executable link path
link_path = Service('/Users/elhadji/Desktop/Python_Labs/chromedriver')
# Creating the “driver”
driver =  webdriver.Chrome(service=link_path)


# ## Create a function to generate a list urls of webpages

# In[3]:


# define a function to build the url
def build_ful_apecurl(keyword_list, pages_numb):
    # Add %20 join strings in keywordlist
    str_keyword = '%20'.join(keyword_list)
    # set apec web page as variable
    root_url = "https://www.apec.fr/candidat/recherche-emploi.html/emploi?motsCles="
    # url page
    url_page = '&page='
    # empty list store full url or each wbepage
    apec_url_list = []
    # full url by contenating in the following list
    for n in pages_numb:
        apec_url_list.append(root_url+str_keyword+url_page+str(n))
    return apec_url_list


# In[4]:


# Keyword to seach : "data scientist" as list two items
keyword_list = ['data', 'scientist']
# page numbers list 
pages_numb = [n for n in range(5)]


# In[5]:


# Build the list of five pages
my_apec_links = build_ful_apecurl(keyword_list, pages_numb)
# print to see 
my_apec_links


# ## Create function to extract data by tagname, class_name, css_selector, xpath

# In[6]:


# Extratct jobs title with driver.find_elements By.TAG_NAME()
def job_title_extractor_tagname(url_list, tag):
    """
    Take an url list and a tag and return all jobs the given webpage
    """
    all_jobs = []
    # loop thorought urls and extract job title by h2 tag
    for url in url_list:
        driver.get(url)
        all_h2 = driver.find_elements(By.TAG_NAME,tag)
        all_jobs += [element.text for element in all_h2]
    # return all_jobs
    return all_jobs
# Probem : It crawl any h2 element in the welpage including job titles 


# In[7]:


# job title tag : h2
tag = "h2"
# get all job titles
job_titles = job_title_extractor_tagname(my_apec_links, tag)
# check the lenght
len(job_titles) 
# Include all h2 elements (job title + other section titles) 


# In[9]:


# Extratct element with driver.find_elements by.CSS_SELECTOR() >  class_name
def job_title_extractor_class(url_list, class_name):
    """
    Take an url list and a class name to return all jobs from all webpages
    """
    all_jobs = []
    for url in url_list:
        driver.get(url)
        all_class = driver.find_elements(By.CSS_SELECTOR,class_name)
        all_jobs += [element.text for element in all_class]

    return all_jobs


# In[10]:


# Class name valie take two as follow when using by.CSS_SELECTOR()
class_name = ".card-title.fs-16"
job_titles = job_title_extractor_class(my_apec_links, class_name) # better than TAG_NAME(), more specific !!!
# check the lenght
len(job_titles)


# In[11]:


print(job_titles[3])


# In[12]:


# find element by XPATH
def job_company_extractor(url_list, class_xpath):
    """
    Take an url and an Xpath to return all job company in a webpage
    """
    all_company = []
    for url in url_list:
        driver.get(url)
        all_comp = driver.find_elements(By.XPATH, class_xpath)
        all_company += [element.text for element in all_comp]
    #driver.quit()
    return all_company


# In[13]:


# define company name xpath
class_xpath = "//*[@class='card-offer__company mb-10']" # company name
# get all the companies
job_company = job_company_extractor(my_apec_links, class_xpath)
# check the lenght
len(job_company)


# In[14]:


print(job_company[3])


# In[15]:


# defien salary xpath 
xpath = '//ul[@class="details-offer"]' # one year salary
# get all the details
job_salary = job_company_extractor(my_apec_links,xpath)
# check the lenght
len(job_salary)


# In[16]:


print(job_salary[3])


# In[20]:


# job description class name
class_name = ".card-offer__description.mb-15" # salary
job_descrition = job_title_extractor_class(my_apec_links, class_name) # using CSS_SELECTOR
# check the lenght
len(job_descrition)


# In[21]:


print(job_descrition[3])


# In[22]:


# Job type, location and date 
class_name = ".details-offer.important-list"
type_loc_date = job_title_extractor_class(my_apec_links, class_name) # using CSS_SELECTOR
# check the lenght
len(type_loc_date)


# In[23]:


print(type_loc_date[3])


# In[24]:


type_loc_date[3]


# ### Create one function that can extrat for mutiples classes by xpath

# In[87]:


# find elementx by XPATH
def jobs_infos_extractor(url_list, xpath_class_list):
    """
    Take an url and an Xpath to return all job infos (title, company, salary, description, ....) from each a webpage
    """
    # jobs characteristics
    all_jobs = [] # job title
    all_company = [] # job company
    all_salary = [] # job salary
    all_description = [] # job description
    all_details = [] # job details (type, location, date)
    for url in url_list:
        driver.get(url)
        # get titles
        all_class = driver.find_elements(By.XPATH, xpath_class_list[0])
        all_jobs += [element.text for element in all_class]
        # get companies
        all_comp = driver.find_elements(By.XPATH, xpath_class_list[1])
        all_company += [element.text for element in all_comp]
        # get salary
        all_sal = driver.find_elements(By.XPATH, xpath_class_list[2])
        all_salary  += [element.text for element in all_sal]
        # get description
        all_descrip = driver.find_elements(By.XPATH, xpath_class_list[3])
        all_description += [element.text for element in all_descrip]
        # get job details
        all_det = driver.find_elements(By.XPATH, xpath_class_list[4])
        all_details += [element.text for element in all_det]      
    # scrapped data now
    return (all_jobs, all_company, all_salary, all_description, all_details)


# In[88]:


# define a function that splits string into list for job details
def string_to_list(text):
    return text.split("\n", 3)


# In[89]:


# testinf string to list function
txt = 'CDI\nBlagnac - 31\n16/11/2021'
string_to_list(txt) # It's working well


# In[90]:


# divide type_loc_date into three lists
job_det = [string_to_list(my_elem) for my_elem in type_loc_date]


# In[92]:


# extract type "0", location "1" or date "2"
type_ = [job_type[0] for job_type in job_det]
loc = [job_type[1] for job_type in job_det]
dat = [job_type[2] for job_type in job_det]


# ## Building csv file function form after scraping www.apec.fr

# In[100]:


def build_apec_csv(keyword_list,xpath_class_list,pages_numb):
    """
    Function that creates a dictionary with all data scrapped from the apec website for data scientist postion
    and store un csv file.
    """
    ###################################################################
    # builf uls bebpages list
    my_apec_links = build_ful_apecurl(keyword_list, pages_numb)
    
    # Five job items to extract
    job_titles, job_company,job_salary,job_descrition,job_details = jobs_infos_extractor(my_apec_links, xpath_class_list)

    # Transform job_details to extract type, loc and date
    type_loc_date = [string_to_list(my_elem) for my_elem in job_details] # call string_to_list function
    # Split type, location and date
    contract = [job_type[0] for job_type in type_loc_date]
    location = [job_type[1] for job_type in type_loc_date]
    date = [job_type[2] for job_type in type_loc_date]
    
    # create a dictionaye to stucture the data scrapped data
    my_dict = {"Job title":job_titles, "Company":job_company, "Salary":job_salary, "Description":job_descrition,
               "Contract":contract, "Location":location, "date":date}
    
    # create a data frame
    data = pd.DataFrame(my_dict)
    
    # store data in csv file
    data.to_csv('/Users/elhadji/Desktop/Python_Labs/aspec_ds_jobs_offers.csv', sep=";", encoding='utf-8', index=False)
    return None


# In[94]:


# make keyword list
keyword_list = ['data', 'scientist']
# page numbers list 
pages_numb = [n for n in range(21)]
# class lists
xpath_class_list = ['//h2[@class="card-title fs-16"]', "//*[@class='card-offer__company mb-10']",
              '//ul[@class="details-offer"]', '//p[@class="card-offer__description mb-15"]', '//ul[@class="details-offer important-list"]']


# In[95]:


# let's build a apec offers data 
build_apec_csv(keyword_list,xpath_class_list,pages_numb)


# ## Exporting scraped data into csv file

# In[96]:


# open the saved data with pand
df = pd.read_csv('/Users/elhadji/Desktop/Python_Labs/aspec_ds_jobs_offers.csv', sep=";")


# In[99]:


# prin the 20 first rows
df.head(20) # 15 firts offers

