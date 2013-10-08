# Class htcondor::config
#
# Configuration deployment for HTCondor
class htcondor::config (
  $is_worker          = false,
  $is_ce              = false,
  $is_manager         = false,
  $condor_host        = $fqdn,
  # pool_password can also be served from central file location using hiera
  $pool_password      = 'puppet:///modules/${module_name}/pool_password',
  # use if condor host has two NICs
  # and only the private should be used for condor
  # use if condor host has two NICs
  # and only the private should be used for condor
  $condor_host_ip     = '',
  $condor_admin_email = 'root@mysite.org',
  $collector_name     = 'Personal Condor at $(FULL_HOSTNAME)',
  $machine_owner      = 'physics',
  $number_of_cpus     = 8,
  $allow_write        = [],
  $uid_domain         = 'example.com',
  # specify the networks with write access i.e. ["10.132.0.*"]
  $managers           = [],
  $computing_elements = [],
  $worker_nodes       = [],) {
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

  # complex preparation of manager, computing_element and worker_nodes lists
  $managers_with_uid_domain           = prefix($managers, 'condor_pool@$(UID_DOMAIN)/'
  )
  $computing_elements_with_uid_domain = prefix($computing_elements, 'condor_pool@$(UID_DOMAIN)/'
  )
  $worker_nodes_with_uid_domain       = prefix($worker_nodes, 'condor_pool@$(UID_DOMAIN)/'
  )

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
  # notify  => Service["condor"], this should be exec {'condor_reconfig':}
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
    source => "$pool_password",
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
