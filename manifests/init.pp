# Class: htcondor
#
# This module manages htcondor
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class htcondor (
  $install_repositories = true,) {
  class { 'htcondor::repositories': install_repos => $install_repositories, }

  class { 'htcondor::install': }

  class { 'htcondor::config': }

  class { 'htcondor::service': }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'] -> Class['htcondor::service'
    ]
}
