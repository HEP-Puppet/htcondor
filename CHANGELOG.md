# Version 2.0.0
Version 2.0.0 brought big changes to the module. The bigest change is a structual one.
`htcondor::params.pp` was added to set defaults for all the parameters.
In addition, parameters are attempted to be read via `hiera` first. Full merge
support for hashes and arrays is provided.
With these changes the `htcondor::config.pp` was split into six pieces:
 - the main config setting up the rest
 - a common config part
 - the security configuration
 - separate configs for manager, scheduler & worker
The full detail of these changes can be seen in [PR 53](https://github.com/HEP-Puppet/htcondor/pull/53).

## New features
- configure connection broker for private workers (i.e. workers that cannot be reached from the manager or scheduler but can reach the manager).
- enabled `ganglia` daemon for schedulers (previously only possible on managers)
- flag to enable [condor reporting](http://research.cs.wisc.edu/htcondor/privacy.html), disabed by default

## Bug fixes
- daemon list would be incorrect for some versions of Ruby. This was due to the use of `and` and `or` operators which is incorrect for boolean comparisons.
- added missing `cluster_has_multiple_domains` parameter (w.r.t to 2.0.0 beta)
- removed repository dependency if it is disabled

## Other
- changed config templates to ensure new line at the end of the file and reduced the use of `-%>` 
- workers are no longer able to write to schedulers by default
- new formatting for the security config: one line per entry for manager/scheduler/worker