# Puppet module for HTCondor batch system

Latest stable version: https://github.com/HEP-Puppet/htcondor/releases/tag/v2.4.3

Development branch: https://github.com/HEP-Puppet/htcondor/tree/development

[![Build Status](https://travis-ci.org/HEP-Puppet/htcondor.svg?branch=master)](https://travis-ci.org/HEP-Puppet/htcondor)

Puppetforge: https://forge.puppetlabs.com/HEPPuppet/htcondor


#### Table of Contents
1. [Overview - What is the htcondor module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with htcondor](#setup)
4. [Singularity container support](#singularity)
5. [Kerberos authentication support](#kerberos)
6. [Additional logging parameters](#logging)
7. [Additional custom parameters](#custom-parameters)
8. [Limitations - OS compatibility, etc.](#limitations)
9. [Development - Guide for contributing to the module](#development)
	* [Contributing to the htcondor module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview
The htcondor modules allows you to set up a HTCondor cluster (https://research.cs.wisc.edu/htcondor/).
It depends on several other modules, including puppetlabs/(stdlib|concat|firewall).
Please check the metadata.json for detailed dependencies.

## Module Description
An HTCondor cluster consists of at least three types of nodes:
 * a worker for executing the jobs
 * a scheduler for job submission
 * a collector/negotiator to match jobs with workers

This puppet modules allows for the configuration of these three types of nodes plus a fourth one:
 * a remote_submit, for local users to login and have a configured condor_submit


## Setup
**What the htcondor module affects:**
 * configuration files and directories (/etc/condor/*)
 * installation of htcondor software (condor* packages)
 * a new fact for facter: condor_version

### Beginning with HTCondor
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
 - settings for remote submit nodes: `htcondor_remote_submit.yaml`

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

## Singularity
The module also provides support for [Singularity](http://singularity.lbl.gov/) containers to the extent to which this is implemented in HTCondor. As compared to e.g. Docker containers, Singularity containers are less isolated and can run without a privileged daemon, granting the user the same permissions inside the container as the user would have on the underlying host. Hence, they are ideal to run HPC jobs.

Example configuration parameters could be:
```
use_singularity          => true,
force_singularity_jobs   => true,
singularity_image_expr   => '"/images/myimage.img"',
singularity_bind_paths   => ['/some_shared_filesystem', '/pool', '/usr/libexec/condor/'],
singularity_target_dir   => '/srv',
starter_job_environment  => { 'SINGULARITY_HOME' => '/srv' },
mount_under_scratch_dirs => ['/tmp','/var/tmp'],
```
This forces all jobs to run inside Singularity containers, while offering `tmp` space inside the container, and binding a shared filesystem mount point and HTCondor-specific directories inside.
The binding of the two HTCondor specific directories is a workaround to allow interactive jobs to run, this will hopefully be fixed in a future HTCondor release.
The same holds for setting `SINGULARITY_HOME`: This ensures non-interactive jobs start in the job's working directory instead of the user's home directory which might not even be accessible from the worker.

The Image in this example is a simple string, but the variable allows to set an HTCondor expression. Hence, for a simple string, one needs to add explicit double quotes. One more complex example relying on a custom JobAd variable `ContainerOS` would be:
```puppet
singularity_image_expr   => 'ifThenElse(TARGET.ContainerOS is "Ubuntu1604", "/somewhere/Ubuntu1604", "/somewhere/SL6")',
```
More details on that are provided in the [HTCondor documentation](http://research.cs.wisc.edu/htcondor/manual/v8.7/SingularitySupport.html).


## Kerberos
The module provides support for Kerberos auth, to the extent to which this is implemented in HTCondor.

Example configuration parameters could be:
```puppet
use_kerberos_auth => true,
krb_srv_keytab    => '/etc/condor/condor.keytab',
krb_srv_principal => 'condor-daemon/$(FULL_HOSTNAME)@MYREALM',
krb_srv_user      => 'condor-daemon',
use_krb_map_file  => true,
krb_mapfile_entries => {'REALM1' =>'realm1', 'REALM2' => 'realm2'},
```
This will deploy a map file containing the entries listed in the `krb_mapfile_entries` hash. The keytab, however, is not deployed through this module and has to be placed to a path corresponding to `krb_srv_keytab`, with the appropriate owner and mode.

## Logging
If you want HTCondor to use custom logging parameters, you may specify `use_custom_logs` and the `logging_parameters` hash with the `{parameter_name => desired_value}` form. For example:
```puppet
use_custom_logs     => true,
logging_parameters => { 'SCHEDD_DEBUG' => 'D_NETWORK,D_PROTOCOL', NEGOTIATOR_DEBUG' => 'D_FULLDEBUG', ... }
```
Please note that no verification is applied, you have to carefully check your syntax to ensure daemons will restart correctly.

If you want HTCondor to log to syslog, there's a specific `log_to_syslog` boolean predefined, which defaults to false. To enable it:
```puppet
use_custom_logs => true,
log_to_syslog   => true,
```

## Custom parameters
If you want HTCondor to use custom parameters which are not managed elsewhere in the module, you may specify `custom_knobs` hash with the `{parameter_name => desired_value}` form. For example:
```puppet
custom_knobs => { 'CLAIM_PARTITIONABLE_LEFTOVERS' => 'false', ... }
```
Please note that:
* no verification is applied, you have to carefully check your syntax to ensure daemons will restart correctly
* these parameters will be deployed on all nodes (workers, schedulers and managers)

## Limitations
### General


## Development

### Contributing
### Running tests
Please run
```bash
bundle exec rake validate && bundle exec rake lint && bundle exec rake spec SPEC_OPTS='--format documentation'
```
and make sure no errors are present when submitting code.

### Generating changlelog
```
export CHANGELOG_GITHUB_TOKEN<your github token>
github_changelog_generator -u hep-puppet -p htcondor
```

### Release instructions
```
export CHANGELOG_GITHUB_TOKEN<your github token>
export RELEASE=2.0.7
make release
# follow instructions
```
