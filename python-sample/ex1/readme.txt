1. install setup tools and python local lambda tool

py -m pip install setuptools
py -m pip install python-lambda-local

2. verify version 
python-lambda-local --version

3. how to use python lambda local 
Go into the folder
python-lambda-local -f lambda_handler lambda_function.py event.json

4. uninstall 
py -m pip uninstall python-lambda-local -y

5. Reinstall cleanly
py -m pip install --upgrade pip setuptools
py -m pip install python-lambda-local


Also we can run same cmd 
py -m lambda_local -f lambda_handler lambda_function.py event.json

6. Unit testing with pytest
pip install pytest
