# Deploy AWS Blueprint 
A basic tool to deploy AWS Instances and MongoDB Atlas Clusters for when using Cloud Formation, Terraform, Habitat, or others is overkill.

# Installation
## From PyPi
Run `pip install DeployBlueprint`

## From Source
Download all source code here. From the root directory of the git clone, run `pip install --editable .`

# Use
## Config file
The script requires a configuration file in `~/.gskyaws.conf` in the same format as [my MongoDBInit/updateAWSSG.sh script](https://github.com/graboskyc/MongoDBInit/blob/master/updateAWSSG.sh).

The format should look like:
```
sgID="sg-YourSGIDfromAWS"
keypair="NameOfYourKeypairFileInAWS"
name="firstname.lastname"
atlasapikey="YourMongoDBAtlasAPIKey"
atlasusername="YourMongoDBAtlasUsernameEmail"
```

## Help
```
graboskycMBP:~ graboskyc$ DeployBlueprint --help
usage: DeployBlueprint [-h] [-b BLUEPRINT] [-s] [-d DAYS] [-k KEYPATH]

CLI Tool to easily deploy a blueprint to aws instances or MongoDB Atlas clusters

optional arguments:
  -h, --help    show this help message and exit
  -b BLUEPRINT  path to the blueprint
  -s, --sample  download a sample blueprint yaml
  -d DAYS       how many days should we reserve this for before reaping
  -k KEYPATH    ssh private key location, required if using tasks
```

## Sample
```
graboskycMBP:~ graboskyc$ DeployBlueprint -b sampleblueprint.yaml
```
## Blueprint Syntax
See the [sampleblueprint.yaml](Samples/sampleblueprint.yaml) for an example. But here is the hierarchy:

| Root | Child | Child | Notes |
|----|---|-|-|
| `apiversion: v1` | | | API version to use, use v1 for now | 
| `metadata` | | | Optional metadata about the blueprint |
| | `blueprint_author` | | (optional) github username |
| | `blueprint_name` | | (optional) name of blueprint to be used in `blueprint-name` aws tag |
| | `blueprint_description` | | (optional) more detail about this blueprint, used in `blueprint-desc` aws tag, capped at 255 char  |
| | `blueprit_version` | |(optional) versioning field of blueprint |
|`resources` | | | begins list of things to dpeloy |
| | `-name` | | name of deployed vm |
| | `description` | | used in description tag |
| | `os` | | `ubuntu`,`rhel`,`win2016dc`, `amazon`, or `amazon2` |
| | `size` | | name of AWS sizes |
| | `postinstallorder` | | order of operations, only use if tasks are provided. Useful for things where one VM must be configured before others. Lower numbers get done before higher ones. |
| | `tasks` | | OPTIONAL and completed in order | 
| | | `-type` | `playbook`, `shell`, `ps`, `local` for ansible or bash/winrm on deployed system, or a local cmd to run on system running `DeployBlueprint` |
| | | `url` | URL to where the script sits, used for `playbook` and `shell` and `ps` only |
| | | `cmd` | command to run in local shell. Used by `local` type only |
| | | `description` | text field to describe what it does |
| `services` | | | list of atlas clusters to deploy|
| | `-name` | | name of cluster to be deployed and will strip all non alphanumerics |
| | `description` | | used for details |
| | `groupid` | | your group within MongoDB Atlas |
| | `backup` | | `true` or `false` to enable backup which has upcharge |
| | `biconnector` | | `true` or `false` to enable BI Connector which has upcharge |
| | `type` | | `REPLICASET` or `SHARDED` or `GEOSHARDED` but first only implemented |
| | `version` | | version of MongoDB and should be `3.4` or `3.6` or `4.0` |
| | `cloud` | | `AWS` or `AZURE` or `GCP` or `TENANT` but only first implemented |
| | `region` | | Cloud Provider region to deploy to, see [the docs](https://docs.atlas.mongodb.com/reference/api/clusters-create-one/) |
| | `size` | | name of the size of machines, see [the docs](https://docs.atlas.mongodb.com/reference/api/clusters-create-one/) |
| | `encrypted` | | `true` or `false` to enable at-rest encryption which has upcharge |
| | `disksize` | | size of data directory disk in GB, only `16` tested |
| | `iops` | | amount of IOPS requested, only `100` tested |
| | `rscount` | | number of nodes in replica set |
| | `shards` | | number of shards, only `1` tested |
| | `postinstallorder` | | required if using tasks, numerical order. Lower numbers get done before higher ones. All tasks for services done after all tasks for instances. |
| | `tasks` | | OPTIONAL and completed in order | 
| | | `-type` | `local` for command to run from local machine running `DeployBlueprint`  |
| | | `cmd` | shell command to run |
| | | `description` | text field to describe what it does |

## Order of operations
* All instances are deployed in the order listed. We use launch instance API and check for pass/fail
* VM names are prepended with a random 8 character string and taged with `use-group` of this UUID so you know they were deployed together
* All Atlas clusters deployed
* Wait for all instances to return `running` state and Atlas to return `IDLE`
* The post configuration plan for Instances is generated as follows:
  * Loop through blueprint and find all resources that have a `task` list
  * Order the resources based on `postinstallorder` in ascending order
  * Tasks for each resource are done in order listed
  * Execute this plan in the order provided
* The post configuration plan for Atlas is generated as follows:
  * Loop through blueprint and find all services that have a `task` list
  * Order the resources based on `postinstallorder` in ascending order
  * Tasks for each resource are done in order listed
  * Execute this plan in the order provided