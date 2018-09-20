from setuptools import *

with open('requirements.txt') as f_required:
    required = f_required.read().splitlines()
with open("readme.md", "r") as fh:
    long_description = fh.read()

setup(
	name='DeployBlueprint',
	version='0.5.5',
	py_modules=['DeployBlueprint'],
	packages=find_packages(),
	install_requires=required,
	long_description=long_description,
    long_description_content_type="text/markdown",
	author="graboskyc",
	author_email="chris@grabosky.net",
	description="This is a basic tool to deploy a series of AWS Instances and MongoDB Atlas Clusters when building a Cloud Formation or using Terraform / Habitat or others is overkill.",
    url="https://github.com/graboskyc/DeployBlueprint",
	entry_points='''
		[console_scripts]
		DeployBlueprint=DeployBlueprint:cli
	''',
)