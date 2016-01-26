#coding=UTF-8
from selenium import webdriver
import time
driver = webdriver.Chrome()
driver.get("https://www.google.ca/webhp?hl=zh-CN")

element = driver.find_element_by_id("lst-ib")
element.send_keys("tablet")
element.submit()
time.sleep(3)
driver.execute_script("window.scrollTo(0,10000);")
time.sleep(3
driver.execute_script("window.scrollTo(0,0);")
time.sleep(3)
driver.quit()
