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
  $allow_write          = [],
  $cluster_has_multiple_domains = false,
  $collector_name       = 'Personal Condor at $(FULL_HOSTNAME)',
  $computing_elements   = [],
  $condor_admin_email   = 'root@mysite.org',
  $condor_host          = $fqdn,
  # use if condor host has two NICs
  # and only the private should be used for condor
  $condor_host_ip       = '',
  $condor_priority      = '99',
  $custom_attribute     = 'NORDUGRID_QUEUE',
  $install_repositories = true,
  $is_ce                = false,
  $is_manager           = false,
  $is_worker            = false,
  $machine_owner        = 'physics',
  $managers             = [],
  $number_of_cpus       = 8,
  $pool_password        = "puppet:///modules/${module_name}/pool_password",
  $uid_domain           = 'example.com',
  $worker_nodes         = [],) {
  class { 'htcondor::repositories':
    install_repos   => $install_repositories,
    condor_priority => $condor_priority,
  }

  class { 'htcondor::install':
  }

  class { 'htcondor::config':
    allow_write        => $allow_write,
    cluster_has_multiple_domains => $cluster_has_multiple_domains,
    collector_name     => $collector_name,
    computing_elements => $computing_elements,
    condor_host        => $condor_host,
    condor_host_ip     => $condor_host_ip,
    condor_admin_email => $condor_admin_email,
    custom_attribute   => $custom_attribute,
    is_ce              => $is_ce,
    is_manager         => $is_manager,
    is_worker          => $is_worker,
    machine_owner      => $machine_owner,
    managers           => $managers,
    number_of_cpus     => $number_of_cpus,
    pool_password      => $pool_password,
    uid_domain         => $uid_domain,
    worker_nodes       => $worker_nodes,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'
    ] -> Class['htcondor::service']
}
