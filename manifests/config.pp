# Class htcondor::config
class htcondor::config {
  # TODO: instead of all the parameters, do it like
  # https://github.com/puppetlabs/puppetlabs-postgresql/blob/master/manifests/server/install.pp
  # parameters are read from init, e.g.
  # $::htcondor::cert_map_file
  $email_domain = $htcondor::email_domain
  $admin_email  = $htcondor::admin_email
  $schedulers = $htcondor::schedulers
  $managers = $htcondor::managers
  $workers = $htcondor::workers

  $is_scheduler = $htcondor::is_scheduler
  $is_manager = $htcondor::is_manager
  $is_worker = $htcondor::is_worker

  $machine_ownder = $htcondor::machine_owner

  # templates
  $template_config_local          = $htcondor::template_config_local
  $template_security              = $htcondor::template_security
  $template_resourcelimits        = $htcondor::template_resourcelimits
  $template_queues                = $htcondor::template_queues
  $template_schedd                = $htcondor::template_schedd
  $template_fairshares            = $htcondor::template_fairshares
  $template_manager               = $htcondor::template_manager
  $template_workernode            = $htcondor::template_workernode
  $template_ganglia               = $htcondor::template_ganglia
  $template_defrag                = $htcondor::template_defrag
  $template_highavailability      = $htcondor::template_highavailability

  $accounting_groups = $htcondor::accounting_groups
  $cluster_has_multiple_domains = $htcondor::cluster_has_multiple_domains
  $collector_name = $htcondor::collector_name
  $custom_attribute = $htcondor::custom_attribute
  $enable_cgroup = $htcondor::enable_cgroup
  $enable_multicore = $htcondor::enable_multicore
  $enable_healthcheck = $htcondor::enable_healthcheck
  $high_priority_groups = $htcondor::high_priority_groups
  $priority_halflife = $htcondor::priority_halflife
  $default_prio_factor = $htcondor::default_prio_factor
  $group_accept_surplus = $htcondor::group_accept_surplus
  $group_autoregroup = $htcondor::group_autoregroup
  $health_check_script = $htcondor::health_check_script
  $include_username_in_accounting = $htcondor::include_username_in_accounting
  $use_pkg_condor_config = $htcondor::use_pkg_condor_config

  $number_of_cpus = $htcondor::number_of_cpus
  $partitionable_slots = $htcondor::partitionable_slots
  $memory_overcommit = $htcondor::memory_overcommit
  $request_memory = $htcondor::request_memory
  # TODO: duplicate?
  $cert_map_file = $htcondor::cert_map_file
  $certificate_mapfile = $htcondor::certificate_mapfile
  $kerberos_mapfile = $htcondor::kerberos_mapfile
  $krb_map_file = $htcondor::krb_map_file

  $pool_home = $htcondor::pool_home
  $queues = $htcondor::queues
  $periodic_expr_interval = $htcondor::periodic_expr_interval
  $max_periodic_expr_interval = $htcondor::max_periodic_expr_interval
  $remove_held_jobs_after = $htcondor::remove_held_jobs_after
  $leave_job_in_queue = $htcondor::leave_job_in_queue
  $ganglia_cluster_name = $htcondor::ganglia_cluster_name
  $pool_password = $htcondor::pool_password
  $pool_create = $htcondor::pool_create
  $uid_domain = $htcondor::uid_domain
  $default_domain_name = $htcondor::default_domain_name
  $filesystem_domain = $htcondor::filesystem_domain
  $use_accounting_groups = $htcondor::use_accounting_groups

  $condor_user = $htcondor::condor_user
  $condor_group = $htcondor::condor_group
  $condor_uid = $htcondor::condor_uid
  $condor_gid = $htcondor::condor_gid

  $use_htcondor_account_mapping = $htcondor::use_htcondor_account_mapping
  $use_fs_auth = $htcondor::use_fs_auth
  $use_password_auth              = $htcondor::use_password_auth
  $use_kerberos_auth              = $htcondor::use_kerberos_auth
  $use_claim_to_be_auth           = $htcondor::use_claim_to_be_auth
  $use_cert_map_file              = $htcondor::use_cert_map_file
  $use_krb_map_file               = $htcondor::use_krb_map_file
  $use_pid_namespaces             = $htcondor::use_pid_namespaces

  $machine_list_prefix = $htcondor::machine_list_prefix
  $max_walltime = $htcondor::max_walltime
  $max_cputime = $htcondor::max_cputime


  # purge all non-managed config files from /etc/condor/config.d
  file { '/etc/condor/config.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  $now                   = strftime('%d.%m.%Y_%H.%M')
  $sched_daemon_list        = ['SCHEDD']
  $worker_daemon_list    = ['STARTD']
  $ganglia_daemon_list   = ['GANGLIAD']
  $auth_string           = construct_auth_string($use_fs_auth,
  $use_password_auth, $use_kerberos_auth, $use_claim_to_be_auth)

  # because HTCondor uses user 'condor_pool' for remote access
  # and user 'condor' for local the variables below need to include
  # both users in case a machine has more than one role (i.e. manager + CE)
  $machine_prefix_local  = "${condor_user}@$(UID_DOMAIN)/"

  $manager_string_remote = join_machine_list($machine_list_prefix, $managers)
  $manager_string_local  = join_machine_list($machine_prefix_local, $managers)
  $manager_string        = join([$manager_string_remote, $manager_string_local], ', '
  )

  $sched_string_remote      = join_machine_list($machine_list_prefix,
  $schedulers)
  $sched_string_local       = join_machine_list($machine_prefix_local,
  $schedulers)
  $sched_string             = join([$sched_string_remote, $sched_string_local], ', ')

  $wn_string_remote      = join_machine_list($machine_list_prefix, $workers
  )
  $wn_string_local       = join_machine_list($machine_prefix_local,
  $workers)
  $wn_string             = join([$wn_string_remote, $wn_string_local], ', ')

  if $enable_multicore {
    $manage_daemon_list = ['COLLECTOR', 'NEGOTIATOR', 'DEFRAG']
  } else {
    $manage_daemon_list = ['COLLECTOR', 'NEGOTIATOR']
  }

  # default daemon, runs everywhere
  $default_daemon_list = ['MASTER']

  if $use_pkg_condor_config {
    $common_config_files = [
      File['/etc/condor/condor_config.local'],
      File['/etc/condor/config.d/10_security.config'],
      ]
  } else {
    $common_config_files = [
      File['/etc/condor/condor_config'],
      File['/etc/condor/condor_config.local'],
      File['/etc/condor/config.d/10_security.config'],
      ]
  }

  if $is_scheduler and $is_manager {
    # machine is both CE and manager (for small sites)
    if $ganglia_cluster_name {
      $temp_list               = concat($default_daemon_list, $sched_daemon_list)
      $temp2_list              = concat($temp_list, $ganglia_daemon_list)
      $daemon_list             = concat($temp2_list, $manage_daemon_list)
      $additional_config_files = [
        File['/etc/condor/config.d/12_resourcelimits.config'],
        File['/etc/condor/config.d/21_schedd.config'],
        File['/etc/condor/config.d/22_manager.config'],
        File['/etc/condor/config.d/23_ganglia.config'],
        ]
      $config_files            = concat($common_config_files,
      $additional_config_files)
    } else {
      $temp_list               = concat($default_daemon_list, $sched_daemon_list)
      $daemon_list             = concat($temp_list, $manage_daemon_list)
      $additional_config_files = [
        File['/etc/condor/config.d/12_resourcelimits.config'],
        File['/etc/condor/config.d/21_schedd.config'],
        File['/etc/condor/config.d/22_manager.config'],
        File['/etc/condor/config.d/33_defrag.config'],
        ]
      $config_files            = concat($common_config_files,
      $additional_config_files)
    }
  } elsif $is_scheduler {
    $daemon_list             = concat($default_daemon_list, $sched_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      ]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_manager {
    # machine running only manager
    if $ganglia_cluster_name {
      $temp_list               = concat($default_daemon_list,
      $manage_daemon_list)
      $daemon_list             = concat($temp_list, $ganglia_daemon_list)
      $additional_config_files = [
        File['/etc/condor/config.d/22_manager.config'],
        File['/etc/condor/config.d/23_ganglia.config'],
        ]
      $config_files            = concat($common_config_files,
      $additional_config_files)
    } else {
      $daemon_list             = concat($default_daemon_list,
      $manage_daemon_list)
      $additional_config_files = [
        File['/etc/condor/config.d/22_manager.config'],
        File['/etc/condor/config.d/33_defrag.config'],
        ]
      $config_files            = concat($common_config_files,
      $additional_config_files)
    }
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
  unless $use_pkg_condor_config {
    file { '/etc/condor/condor_config':
      backup  => ".bak.${now}",
      source  => "puppet:///modules/${module_name}/condor_config",
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }
  }

  file { '/etc/condor/condor_config.local':
    backup  => ".bak.${now}",
    content => template($template_config_local),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
  }

  file { '/etc/condor/config.d/10_security.config':
    content => template($template_security),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
  }

  if $pool_create {
    $condor_directories = [
      $pool_home,
      "${pool_home}/condor",
      '/etc/condor/persistent']
  } else {
    $condor_directories = ['/etc/condor/persistent']
  }

  file { $condor_directories:
    ensure => directory,
    owner  => 'condor',
    mode   => '0644',
  }

  if $use_kerberos_auth {
    if $use_cert_map_file {
      file { $cert_map_file:
        ensure => present,
        source => $certificate_mapfile,
        owner  => $condor_user,
        group  => $condor_group,
      }
    }

    if $use_krb_map_file {
      file { $krb_map_file:
        ensure => present,
        source => $kerberos_mapfile,
        owner  => $condor_user,
        group  => $condor_group,
      }
    }
  }

  if $use_password_auth {
    # even if condor runs as condor, it just drops privileges and needs to start
    # as root.
    # if file is not owned by root, condor will throw this error :
    # 06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real
    # uid
    # 06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real
    # uid
    file { '/etc/condor/pool_password':
      ensure => present,
      source => $pool_password,
      owner  => root,
      group  => root,
      mode   => '0640',
    }
  }

  # files for certain roles
  if $is_scheduler {
    file { '/etc/condor/config.d/12_resourcelimits.config':
      content => template($template_resourcelimits),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }

    file { '/etc/condor/config.d/21_schedd.config':
      content => template($template_schedd),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }

    if $queues {
      file { '/etc/condor/config.d/13_queues.config':
        content => template($template_queues),
        require => Package['condor'],
        owner   => $condor_user,
        group   => $condor_group,
        mode    => '0644',
      }
    }
  }

  if $is_manager {
    if $use_accounting_groups {
      file { '/etc/condor/config.d/11_fairshares.config':
        content => template($template_fairshares),
        require => Package['condor'],
        owner   => $condor_user,
        group   => $condor_group,
        mode    => '0644',
      }
    }

    file { '/etc/condor/config.d/22_manager.config':
      content => template($template_manager),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }

    if $ganglia_cluster_name {
      file { '/etc/condor/config.d/23_ganglia.config':
        content => template($template_ganglia),
        require => Package['condor'],
        owner   => $condor_user,
        group   => $condor_group,
        mode    => '0644',
      }
    }

    file { '/etc/condor/config.d/33_defrag.config':
      content => template($template_defrag),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }

    if size($managers) > 1 {
      $replication_machines = suffix($managers, ':$(REPLICATION_PORT)')
      $had_machines         = suffix($managers, ':$(HAD_PORT)')
      $replication_list     = join($replication_machines, ', ')
      $had_list             = join($had_machines, ', ')

      file { '/etc/condor/config.d/30_highavailability.config':
        content => template($template_highavailability),
        require => Package['condor'],
        owner   => $condor_user,
        group   => $condor_group,
        mode    => '0644',
      }
    }
  }

  if $is_worker {
    file { '/etc/condor/config.d/20_workernode.config':
      content => template($template_workernode),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
    }

    file { '/usr/local/bin/healhcheck_wn_condor':
      source => "${health_check_script}",
      owner  => $condor_user,
      group  => $condor_group,
      mode   => '0655',
    }

  }

  # this exec must be created in the service.pp file if we want to properly
  # handle order including at first run, since the service must be started
  # before the reconfig is done
  # AND there is an upper Class order saying config must be done before starting
  # service.
  # $config_files is already a "File" resouce collection.
  $config_files ~> Exec['/usr/sbin/condor_reconfig']

}
