Puppet module for HTCondor batch system
=========================================
Latest stable version: https://github.com/HEP-Puppet/htcondor/releases/tag/v1.1.0

[![Build Status](https://travis-ci.org/HEP-Puppet/htcondor.svg?branch=master)](https://travis-ci.org/HEP-Puppet/htcondor)

Installation requirements
=========================================
- pool_password file created with ```condor_store_cred -f <path_to_htcondor_module>/files/pool_password```

Tests
=========================================
Please run
```bundle exec rake validate && bundle exec rake lint && bundle exec rake spec SPEC_OPTS='--format documentation'```
and make sure no errors are present when submitting code.

