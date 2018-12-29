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
graboskycMBP:~ graboskyc$ DeployBlueprint -h
usage: DeployBlueprint [-h] [-b BLUEPRINT] [-s] [-d DAYS] [-k KEYPATH] [-l]
                       [-g] [-p] [-r] [-t] [-u UUID]

CLI Tool to easily deploy a blueprint to AWS instances or MongoDB Atlas
clusters

optional arguments:
  -h, --help       show this help message and exit
  -b BLUEPRINT     path to the blueprint
  -s, --sample     download a sample blueprint yaml
  -d DAYS          how many days should we reserve this for before reaping
  -k KEYPATH       ssh private key location, required if using tasks
  -l, --list       instead of deploying, just list deployed instances for a
                   given deployment (use -u flag or defaults to your user)
  -g, --graph      instead of deploying, just build ~/graph.html of deployed
                   instances for a given deployment (use -u flag or defaults
                   to your user)
  -p, --pause      stop or pause a deployment (use -u flag)
  -r, --restart    restart or unpause a deployment (use -u flag)
  -t, --terminate  terminate a deployment (use -u flag)
  -u UUID          when listing or deleting, the uuid of the deployment
```

## Sample
This will download a sample yaml blueprint
```
graboskycMBP:~ graboskyc$ DeployBlueprint -s
Downloading file...
Check your home directory for sample.yaml
```

## Deploy
```
graboskycMBP:~ graboskyc$ DeployBlueprint -b sample.yaml
```

## Manage Deployed Blueprints
### Listing Deployed Blueprints
Use the `-l` flag to list all deployed blueprints. You can use `-l -u <uuid>` if you want to specify just one specific blueprint.
```
graboskycMBP:~ graboskyc$ DeployBlueprint -l

Here is your existing deployment:
+----------------------------------+-------------+---------------+---------------+----------+------------+---------+
| Name              | Pub DNS Name | Public Addr | Private Addr  | Deployment ID | BP Name  | Expires    | State   | 
+-------------------+--------------+-------------+---------------+---------------+----------+------------+---------+
| 6f4a18fa_minikube | REDACTED     | REDACTED    | 172.31.28.242 | 6f4a18fa      | MiniKube | 2019-01-15 | running | 
| aabbee11_sample   | REDACTED     | REDACTED    | 172.31.28.241 | aabbee11      | SAMPLE   | 2019-01-15 | running | 
+----------------------------------+-------------+---------------+---------------+----------+------------+---------+

graboskycMBP:~ graboskyc$ DeployBlueprint -l -u 6f4a18fa

Here is your existing deployment:
+----------------------------------+-------------+---------------+---------------+----------+------------+---------+
| Name              | Pub DNS Name | Public Addr | Private Addr  | Deployment ID | BP Name  | Expires    | State   | 
+----------------------------------+-------------+---------------+---------------+----------+------------+---------+
| 6f4a18fa_minikube | REDACTED     | REDACTED     | 172.31.28.242 | 6f4a18fa      | MiniKube | 2019-01-15 | running | 
+----------------------------------+-------------+---------------+---------------+----------+------------+---------+
```
### Pausing, Restarting, and Terminating Existing Blueprints
* Use the `-p -u <uuid>` to pause (stop) the AWS EC2 instances. 
* Similarly use `-r -u <uuid>` to restart the paused instances.
* Lastly use `-t -u <uuid>` to terminate and destroy the instances for that uuid.

## Blueprint Syntax
See the [sampleblueprint.yaml](Samples/sampleblueprint.yaml) for an example. But here is the hierarchy:

| Root | Child | Child | Notes |
|----|---|-|-|
| `apiversion: v1` | | | API version to use, use v1 for now | 
| `metadata` | | | Optional metadata about the blueprint |
| | `blueprint_author` | | (optional) github username |
| | `blueprint_name` | | (optional) name of blueprint to be used in `blueprint-name` aws tag |
| | `blueprint_description` | | (optional) more detail about this blueprint, used in `blueprint-desc` aws tag, capped at 255 char  |
| | `blueprint_version` | |(optional) versioning field of blueprint |
|`resources` | | | begins list of things to dpeloy |
| | `-name` | | name of deployed vm |
| | `description` | | used in description tag |
| | `os` | | `ubuntu`,`rhel`,`win2016dc`, `amazon`, or `amazon2` but you can also provide the AWS ami ID here |
| | `overrideuser` | | can be specifified to manually specify the user to which run a task. If using a task and an AMI id for `os`, you must provide this |
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
* VM names are prepended with a random 8 character string and taged with `use-group` of this UUID so you know they were deployed together. (Use in combination with the `-l -u` flag to list based on this UUID)
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