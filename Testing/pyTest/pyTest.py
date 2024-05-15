import pytest
from appium import webdriver
from  typing import Any, Dict
from appium.options.common import AppiumOptions
from appium.webdriver.common.appiumby import AppiumBy
from appium.webdriver.appium_service import AppiumService
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import allure
import time

delay = 0.2


@pytest.fixture(scope="function")
def driver_setup_teardown():
    cap: Dict[str, Any] = {
        'platformName': 'Android',
        'deviceName': 'emulator-5554',
        'automationName': 'UiAutomator2'
    }
    url = 'http://localhost:4724'   # appium server url
    driver = webdriver.Remote(url, options=AppiumOptions().load_capabilities(cap))
    yield driver
    driver.quit()

def test_registeration(driver_setup_teardown):
    driver = driver_setup_teardown
    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    wait = WebDriverWait(driver, 10)
    el = wait.until(EC.presence_of_element_located((AppiumBy.XPATH, '//*[@content-desc="REGISTER NOW"]')))

    el.click()

    el = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.widget.EditText").instance(0)')
    el.click()
    el.send_keys("Testing")


    el = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.widget.EditText").instance(1)')
    el.click()
    el.send_keys("1234")


    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='REGISTER')

    allure.attach(driver.get_screenshot_as_png(), name="register_screenshot", attachment_type=allure.attachment_type.PNG)

    el.click()

def test_login(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.widget.EditText").instance(0)')
    el.click()
    el.send_keys("Testing")

    el = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.widget.EditText").instance(1)')
    el.click()
    el.send_keys("1234")

    el = driver.find_element(by=AppiumBy.XPATH, value='//android.widget.Button[@content-desc="LOGIN"]')

    allure.attach(driver.get_screenshot_as_png(), name="login_screenshot", attachment_type=allure.attachment_type.PNG)

    el.click()

def test_purchase(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='viking Jolly Winter Rain Boot Child\n£18.32 - £43.87')
    el.click()

    # scroll down the entire page to reach add to chart
    start_x = 0
    start_y = 500
    end_x = 0
    end_y = -1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)
    
    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='ADD TO CHART')
    el.click()

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()


    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='safety footwear v6471 elk grained leather boots s1p sra\n£22.33 - £29.99')         
    el.click()

    # scroll down the entire page to reach add to chart
    start_x = 0
    start_y = 500
    end_x = 0
    end_y = -1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='ADD TO CHART')
    el.click()

    allure.attach(driver.get_screenshot_as_png(), name="add_to_chart_screenshot", attachment_type=allure.attachment_type.PNG)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Chart\nTab 4 of 5')
    el.click()


    el = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.view.View").instance(8)')
    
    # if element exist, then a failed test case
    assert el is None
    


    el = (driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='BUY NOW'))
    el.click()

def test_main_scroll(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = -1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = 1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = -1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = 1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = -1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0
    end_y = 1500
    driver.swipe(start_x, start_y, end_x, end_y, 1000)

    allure.attach(driver.get_screenshot_as_png(), name="main_scroll_screenshot", attachment_type=allure.attachment_type.PNG)

    start_x = 0
    start_y = 500
    end_x = 0

def test_add_Product(driver_setup_teardown):
    driver = driver_setup_teardown

    def fillTxt(selector,value):
        txt =  driver.find_element(by= AppiumBy.ANDROID_UIAUTOMATOR, value=selector)
        time.sleep(delay)
        txt.click()
        time.sleep(delay)
        txt.send_keys(value)
        time.sleep(delay)

    def pressBtn_XPATH(value):
        btn =  driver.find_element(by= AppiumBy.XPATH, value=value)
        btn.click()

    def pressBtn_ID(value):
        btn =  driver.find_element(by= AppiumBy.ACCESSIBILITY_ID, value=value)
        btn.click()

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)
    
    #### Navigate to Add Product
    pressBtn_ID("add \nTab 3 of 5")

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'Nike 213') # title
    fillTxt("className(\"android.widget.EditText\").instance(1)",'123') # asin
    fillTxt("className(\"android.widget.EditText\").instance(2)",'220')
    fillTxt("className(\"android.widget.EditText\").instance(3)",'Nike') # brand name
    fillTxt("className(\"android.widget.EditText\").instance(4)",'Men shoes') # category

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    # go to next form
    pressBtn_ID("2\nDetails")

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'size: 10')
    fillTxt("className(\"android.widget.EditText\").instance(1)",'Color: Black') # Feature details
    fillTxt("className(\"android.widget.EditText\").instance(2)",'Barcelona') # Location

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    #press Next
    pressBtn_XPATH('//android.widget.Button[@content-desc="Next"]')

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'https://www.nike.com/')
    fillTxt("className(\"android.widget.EditText\").instance(1)",'Cabn/Nikeshoes.png')
    fillTxt("className(\"android.widget.EditText\").instance(2)",'Shoes') # Industry

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    #press confirm
    pressBtn_XPATH('//android.widget.Button[@content-desc="Confirm"]')

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()


    # Test if the product is added or not

    el1 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='2711Mezlan Men\'s Verdi Oxford,Tan,11.5 M\n£188.86')
    el2 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='New Balance Women\'s Rise V1 Cushioning Running Shoe\n£124.23') # New
                              

    # if both elements exist, then test fail
    if el1 is not None and el2 is not None:
        assert False
 
                   
def test_brands(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    time.sleep(1)
    el.click()

    time.sleep(delay)
    
    #### Navigate to Add Product
    el1 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Brands\nTab 2 of 5")
    time.sleep(1)
    el1.click()
    el2 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Visit the Merrell Store")
    time.sleep(1)
    el2.click()
    el3 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Merrell Women'S Bare Access Xtr Trail Running Shoes\n£67.00 - £182.44")
    time.sleep(1)
    el3.click()
    el4 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Back")
    time.sleep(1)
    el4.click()
    el5 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Visit the Kappa Store")
    time.sleep(1)
    el5.click()
    el6 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Kappa Delhi Footwear Unisex, Mesh, Women's Low-Top Sneakers\n£46.18")
    time.sleep(1)
    el6.click()
    el7 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Back")
    time.sleep(1)
    el7.click()

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)

  
   
    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()


    # Test if the product is added or not

    el1 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='2711Mezlan Men\'s Verdi Oxford,Tan,11.5 M\n£188.86')
    el2 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='New Balance Women\'s Rise V1 Cushioning Running Shoe\n£124.23') # New
                              

    # if both elements exist, then test fail
    if el1 is not None and el2 is not None:
        assert False

                   
def test_logout(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    time.sleep(1)
    el.click()

    time.sleep(delay)
    
    el5 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Open navigation menu")
    el5.click()
    el6 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Logout")
    el6.click()

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)

  
   
    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()


    # Test if the product is added or not

    el1 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='2711Mezlan Men\'s Verdi Oxford,Tan,11.5 M\n£188.86')
    el2 = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='New Balance Women\'s Rise V1 Cushioning Running Shoe\n£124.23') # New
                              

    # if both elements exist, then test fail
    if el1 is not None and el2 is not None:
        assert False



def test_add_Operation(driver_setup_teardown):
    driver = driver_setup_teardown

    def fillTxt(selector,value):
        txt =  driver.find_element(by= AppiumBy.ANDROID_UIAUTOMATOR, value=selector)
        time.sleep(delay)
        txt.click()
        time.sleep(delay)
        txt.send_keys(value)
        time.sleep(delay)

    def pressBtn_XPATH(value):
        btn =  driver.find_element(by= AppiumBy.XPATH, value=value)
        btn.click()

    def pressBtn_ID(value):
        btn =  driver.find_element(by= AppiumBy.ACCESSIBILITY_ID, value=value)
        btn.click()

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)
    
    #### Navigate to Add Product
    pressBtn_ID("add \nTab 3 of 5")

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'Nike 213') # title
    fillTxt("className(\"android.widget.EditText\").instance(1)",'123') # asin
    fillTxt("className(\"android.widget.EditText\").instance(2)",'220')
    fillTxt("className(\"android.widget.EditText\").instance(3)",'Nike') # brand name
    fillTxt("className(\"android.widget.EditText\").instance(4)",'Men shoes') # category

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    # go to next form
    pressBtn_ID("2\nDetails")

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'size: 10')
    fillTxt("className(\"android.widget.EditText\").instance(1)",'Color: Black') # Feature details
    fillTxt("className(\"android.widget.EditText\").instance(2)",'Barcelona') # Location

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    #press Next
    pressBtn_XPATH('//android.widget.Button[@content-desc="Next"]')

    ### Fill fields
    fillTxt("className(\"android.widget.EditText\").instance(0)",'https://www.nike.com/')
    fillTxt("className(\"android.widget.EditText\").instance(1)",'Cabn/Nikeshoes.png')
    fillTxt("className(\"android.widget.EditText\").instance(2)",'Shoes') # Industry

    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)


    #press confirm
    pressBtn_XPATH('//android.widget.Button[@content-desc="Confirm"]')

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Back')
    el.click()
                    
def test_search_engine(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    #enter search
    el2 = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.Button")
    el2.click()


    time.sleep(delay)


    el2 = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    el2.click()

    time.sleep(delay)
    el2.send_keys("H")
    time.sleep(delay)
    el2.send_keys("e")
    time.sleep(delay)
    el2.send_keys(" ")
    time.sleep(delay)
    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)
    el2.clear()
    time.sleep(delay)
    el2.send_keys(" S")
    time.sleep(delay)
    el2.send_keys(" e")
    time.sleep(delay)
    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)
    el2.clear()
    time.sleep(delay)
    el2.send_keys("F")
    time.sleep(delay)
    el2.send_keys("i")
    time.sleep(delay)
    el2.send_keys("L")
    time.sleep(delay)
    allure.attach(driver.get_screenshot_as_png(), name="buy_screenshot", attachment_type=allure.attachment_type.PNG)
    el2.clear()
    time.sleep(delay)
    el2.clear()
    time.sleep(delay)



def test_search_sql_injection(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    #enter search
    el2 = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.Button")
    el2.click()


    time.sleep(delay)


    el2 = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")

    el2.click()

    time.sleep(delay)

    el2.send_keys("'; SELECT * FROM marcitest; --")

    

def test_chart_before_purchase(driver_setup_teardown):
    driver = driver_setup_teardown


    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Chart\nTab 4 of 5')
    el.click()


    el1 = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.view.View").instance(3)')

    if el1 is not None:
        assert True


def test_chart_purchase(driver_setup_teardown):
    driver = driver_setup_teardown


    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Chart\nTab 4 of 5')
    el.click()


    el1 = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.view.View").instance(3)')

    if el1 is not None:
        assert True


def test_orders_after_buying(driver_setup_teardown):
    driver = driver_setup_teardown

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')

    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Orders\nTab 5 of 5')
    el.click()


    el1 = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.view.View").instance(8)')

    if el1 is not None:
        assert False


def test_orders_before_buying(driver_setup_teardown):
    driver = driver_setup_teardown


    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='e_commerce_app')
    el.click()

    time.sleep(delay)

    el = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='Orders\nTab 5 of 5')
    el.click()


    el1 = driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value='className("android.view.View").instance(3)')

    if el1 is not None:
        assert True


# pytest -v -s test_integrateAppium.py -k test_add_Product --alluredir="./allureDB/"

# pytest -v -s test_integrateAppium.py -k test_search_engine --alluredir="./allureDB/"

# allure serve allureDB  