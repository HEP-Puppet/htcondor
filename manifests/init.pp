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
  # use if condor host has two NICs
  # and only the private should be used for condor
  $condor_host_ip       = '',
  $condor_admin_email   = 'root@mysite.org',
  $collector_name       = 'Personal Condor at $(FULL_HOSTNAME)',
  $machine_owner        = 'physics',
  $number_of_cpus       = 8,
  # specify the networks with write access i.e. ["10.132.0.*"]
  $allow_write          = [],
  $uid_domain           = 'example.com',
  # specify the networks with write access i.e. ["10.132.0.*"]
  $managers             = [],
  $computing_elements   = [],
  $worker_nodes         = [],) {
  class { 'htcondor::repositories': install_repos => $install_repositories, }

  class { 'htcondor::install': }

  class { 'htcondor::config':
    is_worker          => $is_worker,
    is_ce              => $is_ce,
    is_manager         => $is_manager,
    condor_host        => $condor_host,
    condor_host_ip     => $condor_host_ip,
    condor_admin_email => $condor_admin_email,
    collector_name     => $collector_name,
    machine_owner      => $machine_owner,
    number_of_cpus     => $number_of_cpus,
    allow_write        => $allow_write,
    uid_domain         => $uid_domain,
    managers           => $managers,
    computing_elements => $computing_elements,
    worker_nodes       => $worker_nodes,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'
    ] -> Class['htcondor::service']
}
