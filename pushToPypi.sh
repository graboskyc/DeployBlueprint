#!/bin/bash

# python setup.py sdist upload -r pypi


echo
echo "Incrementing build number..."
echo
cv=`cat version.txt`
nlbn="$(echo $cv | rev | cut -d. -f1 | rev)"
nbn=`echo $nlbn | awk '{$1++; print $0}'`
nb=${cv%.*}"."${nbn}
echo $nb > version.txt

echo
echo "Cleaning..."
echo
./clean.sh

echo
echo "Building and pushing..."
echo
python setup.py sdist
pip install -U wheel
python setup.py bdist_wheel
twine upload dist/*whl dist/*gz