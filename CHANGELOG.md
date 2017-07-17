# Change Log

## [v2.0.2](https://github.com/hep-puppet/htcondor/tree/v2.0.2) (2017-07-17)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v2.0.0...v2.0.2)

**Closed issues:**

- Changes in CentOS7 cgroup setup [\#59](https://github.com/HEP-Puppet/htcondor/issues/59)

**Merged pull requests:**

- Implement SSL authentication [\#65](https://github.com/HEP-Puppet/htcondor/pull/65) ([olifre](https://github.com/olifre))
- htcondor::security Pull CERTIFICATE\_MAPFILE out of krb-auth dependency. [\#64](https://github.com/HEP-Puppet/htcondor/pull/64) ([olifre](https://github.com/olifre))
- Allow to specify the source for certificate and kerberos map files. [\#63](https://github.com/HEP-Puppet/htcondor/pull/63) ([olifre](https://github.com/olifre))
- htcondor::sharedport: Add configuration for condor\_shared\_port daemon. [\#62](https://github.com/HEP-Puppet/htcondor/pull/62) ([olifre](https://github.com/olifre))
- Fix baseurl for yum repositories [\#61](https://github.com/HEP-Puppet/htcondor/pull/61) ([wiene](https://github.com/wiene))

## [v2.0.0](https://github.com/hep-puppet/htcondor/tree/v2.0.0) (2017-07-14)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v1.3.1...v2.0.0)

**Implemented enhancements:**

- Merging development branch into master [\#60](https://github.com/HEP-Puppet/htcondor/pull/60) ([kreczko](https://github.com/kreczko))

**Merged pull requests:**

- Fixing travis tests for Puppet 4.0 [\#67](https://github.com/HEP-Puppet/htcondor/pull/67) ([kreczko](https://github.com/kreczko))

## [v1.3.1](https://github.com/hep-puppet/htcondor/tree/v1.3.1) (2017-05-18)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v1.3.0...v1.3.1)

**Implemented enhancements:**

- Add profiles [\#46](https://github.com/HEP-Puppet/htcondor/issues/46)
- Simplify parameters [\#44](https://github.com/HEP-Puppet/htcondor/issues/44)
- Repository clean up [\#43](https://github.com/HEP-Puppet/htcondor/issues/43)
- Towards version 2.0 - part 3 [\#55](https://github.com/HEP-Puppet/htcondor/pull/55) ([kreczko](https://github.com/kreczko))
- Step 2 towards version 2.0 [\#54](https://github.com/HEP-Puppet/htcondor/pull/54) ([kreczko](https://github.com/kreczko))
- Big simplifications [\#53](https://github.com/HEP-Puppet/htcondor/pull/53) ([kreczko](https://github.com/kreczko))

**Closed issues:**

- security considerations ? [\#42](https://github.com/HEP-Puppet/htcondor/issues/42)
- wrong permissions if condor user != root [\#38](https://github.com/HEP-Puppet/htcondor/issues/38)

**Merged pull requests:**

- Version 1.3.1 [\#52](https://github.com/HEP-Puppet/htcondor/pull/52) ([kreczko](https://github.com/kreczko))
- \[New feature\] high-availability deployment for multiple managers [\#51](https://github.com/HEP-Puppet/htcondor/pull/51) ([kreczko](https://github.com/kreczko))
- 2016 spring clean [\#50](https://github.com/HEP-Puppet/htcondor/pull/50) ([kreczko](https://github.com/kreczko))

## [v1.3.0](https://github.com/hep-puppet/htcondor/tree/v1.3.0) (2016-01-29)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v1.2.0...v1.3.0)

**Implemented enhancements:**

- bumping version to 1.2.0 + tidying up [\#40](https://github.com/HEP-Puppet/htcondor/pull/40) ([kreczko](https://github.com/kreczko))

**Closed issues:**

- Publish on Puppet Forge [\#39](https://github.com/HEP-Puppet/htcondor/issues/39)
- Swap repositories for dependency on grid\_repos [\#3](https://github.com/HEP-Puppet/htcondor/issues/3)

**Merged pull requests:**

- Dropped Puppet 2.7 from tests and added Puppet 4.0 [\#47](https://github.com/HEP-Puppet/htcondor/pull/47) ([kreczko](https://github.com/kreczko))
- enable cgroup [\#41](https://github.com/HEP-Puppet/htcondor/pull/41) ([kashif74](https://github.com/kashif74))

## [v1.2.0](https://github.com/hep-puppet/htcondor/tree/v1.2.0) (2014-11-12)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v1.1.0...v1.2.0)

**Merged pull requests:**

- Added kerberos map file [\#37](https://github.com/HEP-Puppet/htcondor/pull/37) ([kreczko](https://github.com/kreczko))
- setting default FILESYSTEM\_DOMAIN to FQDN \(not all WNs have shared FS\) [\#36](https://github.com/HEP-Puppet/htcondor/pull/36) ([kreczko](https://github.com/kreczko))
- Improving auth method setting [\#35](https://github.com/HEP-Puppet/htcondor/pull/35) ([kreczko](https://github.com/kreczko))
- Condor id fix, better tests and puppet-lint fixes [\#33](https://github.com/HEP-Puppet/htcondor/pull/33) ([kreczko](https://github.com/kreczko))

## [v1.1.0](https://github.com/hep-puppet/htcondor/tree/v1.1.0) (2014-10-16)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/v1.0.0...v1.1.0)

**Closed issues:**

- htcondor files ownership [\#14](https://github.com/HEP-Puppet/htcondor/issues/14)

**Merged pull requests:**

- Exclude condor-i686 and few other bits [\#32](https://github.com/HEP-Puppet/htcondor/pull/32) ([kashif74](https://github.com/kashif74))
- A few small changes [\#31](https://github.com/HEP-Puppet/htcondor/pull/31) ([kreczko](https://github.com/kreczko))
- New feature: ganglia [\#30](https://github.com/HEP-Puppet/htcondor/pull/30) ([kreczko](https://github.com/kreczko))
- New feature: kerberos [\#29](https://github.com/HEP-Puppet/htcondor/pull/29) ([kreczko](https://github.com/kreczko))
- Queues with hiera or config [\#28](https://github.com/HEP-Puppet/htcondor/pull/28) ([kreczko](https://github.com/kreczko))
- Fairshares updated [\#27](https://github.com/HEP-Puppet/htcondor/pull/27) ([kreczko](https://github.com/kreczko))
- email, default and filesystem domains [\#26](https://github.com/HEP-Puppet/htcondor/pull/26) ([kreczko](https://github.com/kreczko))
- Request memory [\#25](https://github.com/HEP-Puppet/htcondor/pull/25) ([kreczko](https://github.com/kreczko))
- adding option for DEV repositories [\#24](https://github.com/HEP-Puppet/htcondor/pull/24) ([kreczko](https://github.com/kreczko))
- Defrag and partitionable slots [\#23](https://github.com/HEP-Puppet/htcondor/pull/23) ([kreczko](https://github.com/kreczko))
- fix ":" -\> "=" [\#22](https://github.com/HEP-Puppet/htcondor/pull/22) ([kreczko](https://github.com/kreczko))

## [v1.0.0](https://github.com/hep-puppet/htcondor/tree/v1.0.0) (2014-08-07)
[Full Changelog](https://github.com/hep-puppet/htcondor/compare/New features...v1.0.0)

**Closed issues:**

- Generic template for fair shares [\#8](https://github.com/HEP-Puppet/htcondor/issues/8)
- Fix fair shares and groups [\#4](https://github.com/HEP-Puppet/htcondor/issues/4)

**Merged pull requests:**

- Added defrag and healthcheck [\#19](https://github.com/HEP-Puppet/htcondor/pull/19) ([kashif74](https://github.com/kashif74))
- make sure condor\_reconfig is not run before service is up [\#18](https://github.com/HEP-Puppet/htcondor/pull/18) ([fschaer](https://github.com/fschaer))
- allow user-defined templates to be specified [\#17](https://github.com/HEP-Puppet/htcondor/pull/17) ([fschaer](https://github.com/fschaer))
- Fix3 [\#16](https://github.com/HEP-Puppet/htcondor/pull/16) ([fschaer](https://github.com/fschaer))
- specify file ownership and allow for user \(root\) override, as this is [\#15](https://github.com/HEP-Puppet/htcondor/pull/15) ([fschaer](https://github.com/fschaer))
- be librarian-puppet friendly [\#13](https://github.com/HEP-Puppet/htcondor/pull/13) ([fschaer](https://github.com/fschaer))
- Changes for seperate scheduler configuartion [\#12](https://github.com/HEP-Puppet/htcondor/pull/12) ([kashif74](https://github.com/kashif74))
- Fixes for Nagios tests [\#11](https://github.com/HEP-Puppet/htcondor/pull/11) ([kreczko](https://github.com/kreczko))
- Fairshare fixes [\#10](https://github.com/HEP-Puppet/htcondor/pull/10) ([kreczko](https://github.com/kreczko))
- Fixes for issues \#4 and \#8 + other stuff [\#9](https://github.com/HEP-Puppet/htcondor/pull/9) ([kreczko](https://github.com/kreczko))
- Updating things for productin [\#7](https://github.com/HEP-Puppet/htcondor/pull/7) ([kreczko](https://github.com/kreczko))
- new version [\#6](https://github.com/HEP-Puppet/htcondor/pull/6) ([kashif74](https://github.com/kashif74))
- Added priority to repo [\#5](https://github.com/HEP-Puppet/htcondor/pull/5) ([kashif74](https://github.com/kashif74))
- First working version of Puppet module for HTCondor [\#1](https://github.com/HEP-Puppet/htcondor/pull/1) ([kreczko](https://github.com/kreczko))

# Version 2.0.0
Version 2.0.0 brought big changes to the module. The biggest change is a structural one.
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
- added `use_anonymous_auth`
- added `custom_machine_attributes` and `custom_machine_attributes` which can be used to add classads for `STARTD_ATTRS` and `STARTD_JOB_ATTRS`

## Bug fixes
- daemon list would be incorrect for some versions of Ruby. This was due to the use of `and` and `or` operators which is incorrect for boolean comparisons.
- added missing `cluster_has_multiple_domains` parameter (w.r.t to 2.0.0 beta)
- removed repository dependency if it is disabled

## Other
- changed config templates to ensure new line at the end of the file and reduced the use of `-%>`
- workers are no longer able to write to schedulers by default
- new formatting for the security config: one line per entry for manager/scheduler/worker
- removed `use_pkg_config` parameter.
- no longer changing `/etc/condor/condor_config` nor `/etc/condor/condor_config.local` as recommended by the HTCondor team
- content previously in `/etc/condor/condor_config.local` now in `/etc/condor/config.d/00_config_local.config`


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*