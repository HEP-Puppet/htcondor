# Class htcondor::config
#
# Configuration deployment for HTCondor
#
# == Parameters:
#
# [*accounting_groups*]
# Accounting grous (and subgroups) for fair share configuration.
# Requires use_accounting_groups = true
# Default just provides an example for what needs to be specified
#
# [*cluster_has_multiple_domains*]
# Specifies if the cluster has more than one domain. If true it will set
# TRUST_UID_DOMAIN = True in 10_security.config
# Default: false
#
# [*collector_name*]
# Sets COLLECTOR_NAME in 22_manager.config
# Default: 'Personal Condor at $(FULL_HOSTNAME)'
#
# [*computing_elements*]
# List of CEs that have access to this HTCondor pool
#
# [*condor_admin_email*]
# Contact email for the pool admin. Sets CONDOR_ADMIN.
#
# [*custom_attribute*]
# Can be used to specify a ClassAd via custom_attribute = True. This is useful
# when creating queues with ARC CEs
# Default: NORDUGRID_QUEUE
#
# [*is_ce*]
# If machine is a computing element or a scheduler (condor term)
#
# [*is_manager*]
# If machine is a manager or a negotiator (condor term)
#
# [*is_worker*]
# If the machine is a worker node
#
# [*machine_owner*]
# The owner of the machine (e.g. an accounting group)
#
# [*managers*]
# List of condor managers
#
# [*number_of_cpus*]
# Number of CPUs available for condor scheduling. This is set for worker nodes
# only
#
# [*pool_password*]
# Path to pool password file.
#
# [*uid_domain*]
# Condor UID_DOMAIN
# Default: example.com
#
# [*use_accounting_groups*]
# If accounting groups should be used (fair shares)
#
# [*worker_nodes*]
# List of worker nodes
#
class htcondor::config (
  $accounting_groups            = {
    'CMS'            => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.80,
    }
    ,
    'CMS.production' => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.95,
    }
  }
  ,
  $cluster_has_multiple_domains = false,
  $collector_name = 'Personal Condor at $(FULL_HOSTNAME)',
  $computing_elements           = [],
  $condor_admin_email           = 'root@mysite.org',
  $custom_attribute             = 'NORDUGRID_QUEUE',
  $is_ce          = false,
  $is_manager     = false,
  $is_worker      = false,
  $machine_owner  = 'physics',
  $managers       = [],
  $number_of_cpus = 8,
  # pool_password can also be served from central file location using hiera
  $pool_password  = "puppet:///modules/${module_name}/pool_password",
  $uid_domain     = 'example.com',
  $use_accounting_groups        = false,
  # specify the networks with write access i.e. ["10.132.0.*"]
  $worker_nodes   = [],) {
  $now                 = strftime('%d.%m.%Y_%H.%M')
  $ce_daemon_list      = ['SCHEDD']
  $worker_daemon_list  = ['STARTD']
  $manage_daemon_list  = ['COLLECTOR', 'NEGOTIATOR']
  # default daemon, runs everywhere
  $default_daemon_list = ['MASTER']
  $common_config_files = [
    File['/etc/condor/condor_config'],
    File['/etc/condor/condor_config.local'],
    File['/etc/condor/config.d/10_security.config'],
    ]

  if $is_ce and $is_manager {
    # machine is both CE and manager (for small sites)
    $temp_list               = concat($default_daemon_list, $ce_daemon_list)
    $daemon_list             = concat($temp_list, $manage_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      File['/etc/condor/config.d/22_manager.config'],
      ]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_ce {
    $daemon_list             = concat($default_daemon_list, $ce_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      ]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_manager {
    # machine running only manager
    $daemon_list             = concat($default_daemon_list, $manage_daemon_list)
    $additional_config_files = [File['/etc/condor/config.d/22_manager.config'],]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_worker {
    $daemon_list             = concat($default_daemon_list, $worker_daemon_list)
    $additional_config_files = [File['/etc/condor/config.d/20_workernode.config'
        ],]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } else {
    $daemon_list  = $default_daemon_list
    $config_files = $common_config_files
  }

  # files common between machines
  file { '/etc/condor/condor_config':
    backup  => ".bak.${now}",
    source  => "puppet:///modules/${module_name}/condor_config",
    require => Package['condor'],
  }

  file { '/etc/condor/condor_config.local':
    backup  => ".bak.${now}",
    content => template("${module_name}/condor_config.local.erb"),
    require => Package['condor'],
  }

  file { '/etc/condor/config.d/10_security.config':
    content => template("${module_name}/10_security.config.erb"),
    require => Package['condor'],
  }

  file { ['/pool', '/pool/condor', '/etc/condor/persistent']:
    ensure => directory,
    owner  => 'condor',
  }

  file { '/etc/condor/pool_password':
    ensure => present,
    source => $pool_password,
  }

  # files for certain roles
  if $is_ce {
    file { '/etc/condor/config.d/12_resourcelimits.config':
      content => template("${module_name}/12_resourcelimits.config.erb"),
      require => Package['condor'],
    }

    file { '/etc/condor/config.d/21_schedd.config':
      content => template("${module_name}/21_schedd.config.erb"),
      require => Package['condor'],
    }

  }

  if $is_manager {
    if $use_accounting_groups {
      file { '/etc/condor/config.d/11_fairshares.config':
        content => template("${module_name}/11_fairshares.config.erb"),
        require => Package['condor'],
      }
    }

    file { '/etc/condor/config.d/22_manager.config':
      content => template("${module_name}/22_manager.config.erb"),
      require => Package['condor'],
    }
    # TODO: high availability
    # TODO: defrag
  }

  if $is_worker {
    file { '/etc/condor/config.d/20_workernode.config':
      content => template("${module_name}/20_workernode.config.erb"),
      require => Package['condor'],
    }
  }

  exec { '/usr/sbin/condor_reconfig':
    subscribe   => $config_files,
    refreshonly => true,
  }
}
