#coding=UTF-8
from selenium import webdriver
driver = webdriver.Chrome()
driver.get("http://dict.youdao.com/")

element = driver.find_element_by_id("query")
element.send_keys("tablet")
element.submit()
driver.find_element_by_id("query").send_keys("code")
driver.find_element_by_id("query").submit()
#driver.quit()
