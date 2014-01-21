# Class htcondor::config
#
# Configuration deployment for HTCondor
class htcondor::config (
  $allow_write        = [],
  $cluster_has_multiple_domains = false,
  $collector_name     = 'Personal Condor at $(FULL_HOSTNAME)',
  $computing_elements = [],
  $condor_admin_email = 'root@mysite.org',
  $condor_host        = $fqdn,
  # use if condor host has two NICs
  # and only the private should be used for condor
  $condor_host_ip     = '',
  $custom_attribute   = 'NORDUGRID_QUEUE',
  $is_ce              = false,
  $is_manager         = false,
  $is_worker          = false,
  $machine_owner      = 'physics',
  $managers           = [],
  $number_of_cpus     = 8,
  $uid_domain         = 'example.com',
  # specify the networks with write access i.e. ["10.132.0.*"]
  $worker_nodes       = [],) {
  $now = strftime('%d.%m.%Y_%H.%M')
  $ce_daemon_list = ['SCHEDD']
  $worker_daemon_list = ['STARTD']
  $manage_daemon_list = ['COLLECTOR', 'NEGOTIATOR']

  # default daemon, runs everywhere
  $default_daemon_list = ['MASTER']
  $common_config_files = [
    File['/etc/condor/condor_config'],
    File['/etc/condor/condor_config.local'],
    File['/etc/condor/config.d/10_security.config'],
    ]

  if $is_ce and $is_manager {
    # machine is both CE and manager (for small sites)
    $temp_list = concat($default_daemon_list, $ce_daemon_list)
    $daemon_list = concat($temp_list, $manage_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      File['/etc/condor/config.d/22_manager.config'],
      ]
    $config_files = concat($common_config_files, $additional_config_files)
  } elsif $is_ce {
    $daemon_list = concat($default_daemon_list, $ce_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      ]
    $config_files = concat($common_config_files, $additional_config_files)
  } elsif $is_worker {
    $daemon_list = concat($default_daemon_list, $worker_daemon_list)
    $additional_config_files = [File['/etc/condor/config.d/20_workernode.config'
        ],]
    $config_files = concat($common_config_files, $additional_config_files)
  } else {
    $daemon_list = $default_daemon_list
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
  # notify  => Service["condor"], this should be exec {'condor_reconfig':}
  }

  class { 'htcondor::config::security':
    cluster_has_multiple_domains => $cluster_has_multiple_domains,
    computing_elements           => $computing_elements,
    managers                     => $managers,
    uid_domain                   => $uid_domain,
    worker_nodes                 => $worker_nodes,
  }

  file { ['/pool', '/pool/condor', '/etc/condor/persistent']:
    ensure => directory,
    owner  => 'condor',
  }

  file { '/etc/condor/pool_password':
    ensure => present,
    source => "puppet:///modules/${module_name}/pool_password",
  }

  # files for certain roles
  if $is_ce {
    file { '/etc/condor/config.d/12_resourcelimits.config':
      source  => "puppet:///modules/${module_name}/12_resourcelimits.config",
      require => Package['condor'],
    }

    file { '/etc/condor/config.d/21_schedd.config':
      content => template("${module_name}/21_schedd.config.erb"),
      require => Package['condor'],
    }

  }

  if $is_manager {
    # TODO: fair shares
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
