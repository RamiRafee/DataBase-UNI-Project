// Appium installation
----------------------

1) Appium 
https://appium.io/docs/en/2.2/quickstart/install/


2) Appium inspector
https://github.com/appium/appium-inspector/releases





// Python Libraries
-------------------

-- pip install -U pytest

+ Any library that gives errors, pip it :)


----------------------------------------------------------------------------------

// Allure tool
--------------



Windows:
-------
- First install scoop --> https://github.com/ScoopInstaller/Install#readme
- Then install Allure via scoop --> https://allurereport.org/docs/install-for-windows/


MAC:
----
- First install brew --> https://brew.sh/
- Then Allure via brew --> https://allurereport.org/docs/install-for-macos/


--------------------------------------------------------------------------------

// Commands to run in vs code terminal

-- Note, function name must start with test_<name>

1) Run script

- pytest -v -s <filename>.py -k test_<name> --alluredir="./<dirName>"
-------------------------- Replace each <>

2) Generate Allure report

- allure serve <dirName>
-------------------------- Replace <dirName> with the name u created earlier  