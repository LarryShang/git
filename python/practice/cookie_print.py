#coding=UTF-8
from selenium import webdriver
import time
driver = webdriver.Chrome()
driver.get("https://www.youdao.com")

cookie = driver.get_cookies()
print cookie
driver.add_cookie({'name':'keyaaa','value':'keybbb'})
for cookie in driver.get_cookies():
  print "%s -> %s" % (cookie['name'], cookie['value'])
driver.quit()
