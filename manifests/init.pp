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
  $install_repositories = true,
  $is_worker            = false,
  $condor_host          = $fqdn,
  $allow_write          = [
    ]) {
  class { 'htcondor::repositories': install_repos => $install_repositories, }

  class { 'htcondor::install': }

  class { 'htcondor::config':
    is_worker   => $is_worker,
    condor_host => $condor_host,
    allow_write => $allow_write,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'] -> Class['htcondor::service'
    ]
}
