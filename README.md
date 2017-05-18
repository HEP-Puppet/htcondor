#Puppet module for HTCondor batch system

Latest stable version: https://github.com/HEP-Puppet/htcondor/releases/tag/v1.3.1

Development branch (heading for 2.0.0): https://github.com/HEP-Puppet/htcondor/tree/development

[![Build Status](https://travis-ci.org/HEP-Puppet/htcondor.svg?branch=master)](https://travis-ci.org/HEP-Puppet/htcondor)

Puppetforge: https://forge.puppetlabs.com/HEPPuppet/htcondor


####Table of Contents
1. [Overview - What is the htcondor module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with htcondor](#setup)
4. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
	* [Contributing to the htcondor module](#contributing)
    * [Running tests - A quick guide](#running-tests)

##Overview
The htcondor modules allows you to set up a HTCondor cluster (https://research.cs.wisc.edu/htcondor/).
It depends on several other modules, including puppetlabs/(stdlib|concat|firewall).
Please check the metadata.json for detailed dependencies.

##Module Description
An HTCondor cluster consists of at least three types of nodes:
 * a worker for executing the jobs
 * a scheduler for job submission
 * a collector/negotiator to match jobs with workers

This puppet modules allows for the configuration of these three types of nodes.


##Setup
**What the htcondor module affects:**
 * configuration files and directories (/etc/condor/*)
 * installation of htcondor software (condor* packages)
 * a new fact for facter: condor_version

###Beginning with HTCondor
Since admins might wish to run their own repository or disable repositories after install,
the HTCondor repository is no longer included in the Puppet module since version 2.0.0.
Therefore, the first step is to install the latest HTCondor repository for your OS (https://research.cs.wisc.edu/htcondor/yum/):
```
yum install -y https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel6.repo
```
If you wish to use a [pool password for authentication](http://research.cs.wisc.edu/htcondor/manual/latest/3_6Security.html#SECTION00463400000000000000) you will need to create one first: ```condor_store_cred -f <path_to_htcondor_module>/files/pool_password```.

### Examples
`hiera` config examples can be found in the examples folder. They describe a minimal example of
 - settings shared across different node types: `htcondor_common.yaml`
 - settings for managers (nodes that run collector & negotiator daemons): `htcondor_manager.yaml`
 - settings for schedulers: `htcondor_scheduler.yaml`
 - settings for worker nodes: `htcondor_common.yaml`
The examples assume class management in hiere by adding  `hiera_include('classes')` to the `site.pp`.
Real life examples can be found in https://github.com/uobdic/UKI-SOUTHGRID-BRIS-HEP.

## Custom machine/job attributes
Sometimes it is necessary to create custom attributes for condor. Machine attributes can be used
in job requirements (e.g. `HasMatLab = True`) and job attributes for job reporting/monitoring (e.g. `HEPSPEC06 = 14.00`).
To specify the attributes in hiera simply add
```
htcondor::custom_attributes:
  - HasMatLab: True
  ...
```
and for job attributes
```
htcondor::custom_job_attributes:
  - HEPSPEC06: 14.00
  - CPUScaling: 1.04
  ...
```
Although the use is identical, they are put into different places. `custom_attributes` end up added to the `STARTD_ATTRS`
and `custom_job_attributes` are added to `STARTD_JOB_ATTRS`.

##Limitations
###General


##Development

###Contributing
###Running tests
Please run
```bundle exec rake validate && bundle exec rake lint && bundle exec rake spec SPEC_OPTS='--format documentation'```
and make sure no errors are present when submitting code.

### Generating changlelog
```
github_changelog_generator -u hep-puppet -p htcondor
```
