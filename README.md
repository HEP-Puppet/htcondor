Puppet module for HTCondor batch system
=========================================

[![Build Status](https://www.travis-ci.org/kreczko/puppet-htcondor.png?branch=master)](https://www.travis-ci.org/kreczko/puppet-htcondor)

Installation requirements
=========================================
- pool_password file created with ```condor_store_cred -f <path_to_htcondor_module>/files/pool_password```

Tests
=========================================
Please run
```bundle exec rake validate && bundle exec rake lint && bundle exec rake spec SPEC_OPTS='--format documentation'```
and make sure no errors are present when submitting code.

