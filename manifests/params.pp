# htcondor::params
class htcondor::params {
  $schedulers                     = hiera_array('schedulers', [])
  $managers                       = hiera_array('managers', [])
  $workers                        = hiera_array('workers', [])

  $is_manager                     = hiera('is_manager', false)
  $is_scheduler                   = hiera('is_scheduler', false)
  $is_remote_submit               = hiera('is_remote_submit', false)
  $is_worker                      = hiera('is_worker', false)

  $cluster_has_multiple_domains   = hiera('cluster_has_multiple_domains', false)
  $collector_name                 = hiera('collector_name', 'Personal Condor at $(FULL_HOSTNAME)'
  )
  $collector_query_workers        = hiera('collector_query_workers', 16)
  $collector_max_file_descriptors = hiera('collector_max_file_descriptors', undef)
  $repo_priority                  = hiera('repo_priority', '99')
  $condor_version                 = hiera('condor_version', 'present')
  $custom_machine_attributes      = hiera_hash('custom_machine_attribute', {})
  $custom_job_attributes          = hiera_hash('custom_job_attributes', {})
  $claim_worklife                 = hiera('claim_worklife', 0)

  $use_debug_notify               = hiera('use_debug_notify', true)

  # this is one of the funding requirements for HTCondor
  # for more information see https://research.cs.wisc.edu/htcondor/privacy.html
  $enable_condor_reporting        = hiera('enable_condor_reporting', true)
  $enable_cgroup                  = hiera('enable_cgroup', false)
  $enable_healthcheck             = hiera('enable_healthcheck', false)
  $start_always_users             = hiera_array('start_always_users', [])
  $enable_multicore               = hiera('enable_multicore', false)
  # defrag parameters
  $defrag_interval                 = hiera('defrag_interval',600)
  $defrag_draining_machines_per_hr = hiera('defrag_draining_machines_per_hr',60)
  $defrag_max_concurrent_draining  = hiera('defrag_max_concurrent_draining',8)
  $defrag_max_whole_machines       = hiera('defrag_max_whole_machines',20)
  $defrag_schedule                 = hiera('defrag_schedule','graceful')
  $defrag_rank                     = hiera('defrag_rank','ifThenElse(Cpus >= 8, -10, (TotalCpus - Cpus)/(8.0 - Cpus))')
  $whole_machine_cpus              = hiera('whole_machine_cpus',8)
  $defrag_requirements             = hiera('defrag_requirements','PartitionableSlot && Offline =!= True && StartJobs =?= True')

  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
    $htcondor_cgroup_default = '/system.slice/condor.service'
  }
  else {
    $htcondor_cgroup_default = 'htcondor'
  }
  $htcondor_cgroup                = hiera('htcondor_cgroup', $htcondor_cgroup_default)
  $cgroup_memory_limit            = hiera('cgroup_memory_limit', 'soft')

  $high_priority_groups           = hiera_hash('high_priority_groups', undef)

  $default_accounting_groups      = {
    'CMS'            => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.80,
    }
    ,
    'CMS.production' => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.95,
    },
  }
  $accounting_groups              = hiera_hash('accounting_groups',
  $default_accounting_groups)

  $priority_halflife              = hiera('priority_halflife', 43200)
  $default_prio_factor            = hiera('default_prio_factor', 100000.00)
  $group_accept_surplus           = hiera('group_accept_surplus', true)
  $group_autoregroup              = hiera('group_autoregroup', true)

  $healthcheck_path               = hiera('healthcheck_path', '/usr/local/bin/healthcheck_wn_condor')
  $healthcheck_script             = hiera('healthcheck_script', "puppet:///modules/${module_name}/healthcheck_wn_condor"
  )
  $healthcheck_period             = hiera('healthcheck_period', '10m')
  $include_username_in_accounting = hiera('include_username_in_accounting',
  false)
  $install_repositories           = hiera('install_repositories', true)
  $gpgcheck                       = hiera('gpgcheck', true)
  $gpgkey                         = hiera('gpgkey', 'https://research.cs.wisc.edu/htcondor/repo/keys/RPM-GPG-KEY-HTCondor')
  $apt_key_id                     = hiera('apt_key_id', '4B9D355DF3674E0E272D2E0A973FC7D2670079F6')
  $apt_key_source                 = hiera('apt_key_source', 'https://research.cs.wisc.edu/htcondor/repo/keys/HTCondor-Release.gpg.key')
  $condor_major_version           = hiera('condor_major_version', '8.8')
  $versioned_repos                = hiera('versioned_repos', false)
  $dev_repositories               = hiera('dev_repositories', false)

  $machine_owner                  = hiera('machine_owner', 'physics')

  $number_of_cpus                 = hiera('number_of_cpus', $facts['processors']['count'],
  )

  $partitionable_slots            = hiera('partitionable_slots', true)
  $memory_overcommit              = hiera('memory_overcommit', 1.5)
  $request_memory                 = hiera('request_memory', true)

  $starter_job_environment        = hiera_hash('starter_job_environment', {})
  $manage_selinux                 = hiera('manage_selinux', true)
  $pool_home                      = hiera('pool_home', '/pool')
  $pool_create                    = hiera('pool_create', true)
  $mount_under_scratch_dirs       = hiera_array('mount_under_scratch_dirs', ['/tmp', '/var/tmp'])
  $queues                         = hiera('grid_queues', undef)
  $periodic_expr_interval         = hiera('periodic_expr_interval', 60)
  $max_periodic_expr_interval     = hiera('max_periodic_expr_interval', 1200)
  $remove_held_jobs_after         = hiera('remove_held_jobs_after', 1200)
  $leave_job_in_queue             = hiera('leave_job_in_queue', false)
  $max_walltime                   = hiera('max_walltime', '80 * 60 * 60')
  $max_cputime                    = hiera('max_cputime', '80 * 60 * 60')
  $memory_factor                  = hiera('memory_factor', '1000')
  $dns_cache_refresh              = hiera('dns_cache_refresh', 28800+fqdn_rand(600, 'htcondor_dns_cache_refresh'))

  $ganglia_cluster_name           = hiera('ganglia_cluster_name', undef)

  $uid_domain                     = hiera('uid_domain', 'example.org')
  $default_domain_name            = hiera('default_domain_name', $uid_domain)
  $filesystem_domain              = hiera('filesystem_domain', $facts['networking']['fqdn'])

  $use_accounting_groups          = hiera('use_accounting_groups', false)
  $use_htcondor_account_mapping   = hiera('use_htcondor_account_mapping', true)

  # service security
  $condor_user                    = hiera('condor_user', root)
  $condor_group                   = hiera('condor_group', root)
  $condor_uid                     = hiera('condor_uid', 0)
  $condor_gid                     = hiera('condor_gid', 0)

  # authentication
  $queue_super_users              = hiera_array('queue_super_users', [])
  $queue_super_user_impersonate   = hiera('queue_super_user_impersonate', '')
  $use_anonymous_auth             = hiera('use_anonymous_auth', false)
  $use_fs_auth                    = hiera('use_fs_auth', true)
  $use_password_auth              = hiera('use_password_auth', true)
  $use_kerberos_auth              = hiera('use_kerberos_auth', false)
  $use_claim_to_be_auth           = hiera('use_claim_to_be_auth', false)
  $use_ssl_auth                   = hiera('use_ssl_auth', false)
  $use_cert_map_file              = hiera('use_cert_map_file', false)
  $use_krb_map_file               = hiera('use_krb_map_file', false)
  $use_pid_namespaces             = hiera('use_pid_namespaces', false)
  $cert_map_file                  = hiera('cert_map_file', '/etc/condor/certificate_mapfile'
  )
  $cert_map_file_source           = hiera('cert_map_file_source', "puppet:///modules/${module_name}/certificate_mapfile"
  )
  $krb_map_file                   = hiera('krb_map_file', '/etc/condor/kerberos_mapfile'
  )
  $krb_map_file_template          = hiera('krb_map_file_template', "${module_name}/mapfile.kmap.erb"
  )
  $machine_list_prefix            = hiera('machine_list_prefix', 'condor_pool@$(UID_DOMAIN)/'
  )
  $pool_password_file             = hiera('pool_password_file', "puppet:///modules/${module_name}/pool_password"
  )
  $users_list                     = hiera('users_list', '*@$(UID_DOMAIN)')
  $ssl_server_keyfile             = hiera('ssl_server_keyfile', '')
  $ssl_client_keyfile             = hiera('ssl_client_keyfile', '')
  $ssl_server_certfile            = hiera('ssl_server_certfile', '')
  $ssl_client_certfile            = hiera('ssl_client_certfile', '')
  $ssl_server_cafile              = hiera('ssl_server_cafile', '')
  $ssl_client_cafile              = hiera('ssl_client_cafile', '')
  $ssl_server_cadir               = hiera('ssl_server_cadir', '')
  $ssl_client_cadir               = hiera('ssl_client_cadir', '')

  # for private networks
  $uses_connection_broker         = hiera('uses_connection_broker', false)
  $private_network_name           = hiera('private_network_name', $facts['networking']['domain'])

  # Schedd configuration
  $schedd_blocked_users           = hiera_array('schedd_blocked_users', [])
  $schedd_blocked_user_msg        = hiera('schedd_blocked_user_msg', 'Submission is blocked for you, please contact cluster admins.')

  # Job default resource requests. These are interpreted as expressions.
  $job_default_requestcpus        = hiera('job_default_requestcpus', '1')
  $job_default_requestdisk        = hiera('job_default_requestdisk', 'DiskUsage')
  $job_default_requestmemory      = hiera(
    'job_default_requestmemory',
    'ifthenelse(MemoryUsage =!= UNDEFINED,MemoryUsage,(ImageSize+1023)/1024)'
  )

  # SharedPort service configuration
  $use_shared_port                = hiera('use_shared_port', false)
  $shared_port                    = hiera('shared_port', 9618)
  $shared_port_collector_name     = hiera('shared_port_collector_name', 'collector')

  # History parameters on schedd
  $max_history_log                = hiera('max_history_log', 104857600)
  $max_history_rotations          = hiera('max_history_rotations', 14)
  $rotate_history_daily           = hiera('rotate_history_daily', true)

  # Custom logging config
  $use_custom_logs                = hiera('use_custom_logs', false)
  $log_to_syslog                  = hiera('log_to_syslog', false)
  $logging_parameters             = hiera('logging_parameters', {})

  # Custom knobs config
  $custom_knobs                   = hiera('custom_knobs', {})

  # Singularity configuration
  $use_singularity                = hiera('use_singularity', false)
  $singularity_path               = hiera('singularity_path', '/usr/bin/singularity')
  $force_singularity_jobs         = hiera('force_singularity_jobs', false)
  $singularity_image_expr         = hiera('singularity_image', 'SingularityImage')
  $singularity_bind_paths         = hiera_array('singularity_bind_paths', 'SingularityBind')
  $singularity_target_dir         = hiera('singularity_target_dir', '')

  # notification settings
  $admin_email                    = hiera('admin_email', 'localhost')
  $email_domain                   = hiera('email_domain', 'localhost')
  # template paths
  $template_config_local          = hiera('template_config_local',
  "${module_name}/condor_config.local.erb")
  $template_security              = hiera('template_security', "${module_name}/10_security.config.erb"
  )
  $template_resourcelimits        = hiera('template_resourcelimits',
  "${module_name}/12_resourcelimits.config.erb")
  $template_queues                = hiera('template_queues', "${module_name}/13_queues.config.erb"
  )
  $template_schedd                = hiera('template_schedd', "${module_name}/21_schedd.config.erb"
  )
  $template_fairshares            = hiera('template_fairshares', "${module_name}/11_fairshares.config.erb"
  )
  $template_manager               = hiera('template_collector', "${module_name}/22_manager.config.erb"
  )
  $template_ganglia               = hiera('template_ganglia', "${module_name}/23_ganglia.config.erb"
  )
  $template_workernode            = hiera('template_workernode', "${module_name}/20_workernode.config.erb"
  )
  $template_defrag                = hiera('template_defrag', "${module_name}/33_defrag.config.erb"
  )
  $template_highavailability      = hiera('template_defrag', "${module_name}/30_highavailability.config.erb"
  )
  $template_sharedport            = hiera('template_sharedport', "${module_name}/27_shared_port.config.erb"
  )
  $template_logging               = hiera('template_logging', "${module_name}/14_logging.config.erb"
  )
  $template_custom_knobs          = hiera('template_custom_knobs', "${module_name}/60_custom_knobs.config.erb"
  )
  $template_singularity           = hiera('template_singularity', "${module_name}/50_singularity.config.erb"
  )
}
