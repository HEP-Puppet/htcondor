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
  $is_ce                = false,
  $is_manager           = false,
  $condor_host          = $fqdn,
  $condor_admin_email   = 'root@mysite.org',
  $collector_name       = 'Personal Condor at $(FULL_HOSTNAME)',
  $machine_owner        = 'physics',
  $number_of_cpus       = 8,
  # specify the networks with write access i.e. ["10.132.0.*"]
  $allow_write          = [],) {
  class { 'htcondor::repositories': install_repos => $install_repositories, }

  class { 'htcondor::install': }

  class { 'htcondor::config':
    is_worker          => $is_worker,
    is_ce              => $is_ce,
    is_manager         => $is_manager,
    condor_host        => $condor_host,
    condor_admin_email => $condor_admin_email,
    collector_name     => $collector_name,
    machine_owner      => $machine_owner,
    number_of_cpus     => $number_of_cpus,
    allow_write        => $allow_write,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'
    ] -> Class['htcondor::service']
}
