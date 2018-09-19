#!/bin/bash

# python setup.py sdist upload -r pypi

python setup.py sdist
pip install -U wheel
python setup.py bdist_wheel
twine upload dist/*whl dist/*gz
