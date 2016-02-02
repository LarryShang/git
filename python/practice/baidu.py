#coding=UTF-8
from selenium import webdriver
from time import sleep
file_info = open('search.txt','r')
contents = file_info.readlines()
driver = webdriver.Chrome()
driver.get("http://www.baidu.com/")
for search in contents:
  driver.find_element_by_id("kw").clear()
  driver.find_element_by_id("kw").send_keys(search)
  driver.find_element_by_id("su").click()
  sleep(3)
driver.quit()
