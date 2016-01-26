#coding=UTF-8
from selenium import webdriver
from time import sleep
driver = webdriver.Chrome()
driver.get("https://www.google.ca/webhp?hl=zh-CN")

element = driver.find_element_by_id("lst-ib")
element.send_keys("tablet")
element.submit()
sleep(3)
element.clear()
element.send_keys("code")
element.submit()
#driver.quit()
