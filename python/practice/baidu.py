#coding=UTF-8
from selenium import webdriver
driver = webdriver.Chrome()
#WebDriver driver = new RemoteWebDriver("http://localhost:9515", DesiredCapabilities.chrome())
driver.get("http://www.baidu.com/")

driver.find_element_by_id("kw").send_keys("tablet")
driver.find_element_by_id("su").click()
#driver.quit()
