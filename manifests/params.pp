# htcondor::params
class htcondor::params {
  $schedulers                     = hiera_array('schedulers', [])
  $managers                       = hiera_array('managers', [])
  $workers                        = hiera_array('workers', [])

  $is_manager                     = hiera('is_manager', false)
  $is_scheduler                   = hiera('is_scheduler', false)
  $is_worker                      = hiera('is_worker', false)

  $cluster_has_multiple_domains   = hiera('cluster_has_multiple_domains', false)
  $collector_name                 = hiera('collector_name', 'Personal Condor at $(FULL_HOSTNAME)'
  )
  $repo_priority                  = hiera('repo_priority', '99')
  $condor_version                 = hiera('condor_version', 'present')
  $custom_attribute               = hiera('custom_attribute', 'NORDUGRID_QUEUE')

  $enable_cgroup                  = hiera('enable_cgroup', false)
  $enable_multicore               = hiera('enable_multicore', false)
  $enable_healthcheck             = hiera('enable_healthcheck', false)

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
    }
  }
  $accounting_groups              = hiera_hash('accounting_groups',
  $default_accounting_groups)

  $priority_halflife              = hiera('priority_halflife', 43200)
  $default_prio_factor            = hiera('default_prio_factor', 100000.00)
  $group_accept_surplus           = hiera('group_accept_surplus', true)
  $group_autoregroup              = hiera('group_autoregroup', true)

  $health_check_script            = hiera('health_check_script', "puppet:///modules/${module_name}/healhcheck_wn_condor"
  )
  $include_username_in_accounting = hiera('include_username_in_accounting',
  false)
  $use_pkg_condor_config          = hiera('use_pkg_condor_config', false)
  $install_repositories           = hiera('install_repositories', true)
  $dev_repositories               = hiera('dev_repositories', false)

  $machine_owner                  = hiera('machine_owner', 'physics')

  $number_of_cpus                 = hiera('number_of_cpus', $::processors['count'
    ])

  $partitionable_slots            = hiera('partitionable_slots', true)
  $memory_overcommit              = hiera('memory_overcommit', 1.5)
  $request_memory                 = hiera('request_memory', true)

  $pool_home                      = hiera('pool_home', '/pool')
  $pool_create                    = hiera('pool_create', true)
  $queues                         = hiera('grid_queues', undef)
  $periodic_expr_interval         = hiera('periodic_expr_interval', 60)
  $max_periodic_expr_interval     = hiera('max_periodic_expr_interval', 1200)
  $remove_held_jobs_after         = hiera('remove_held_jobs_after', 1200)
  $leave_job_in_queue             = hiera('leave_job_in_queue', undef)
  $max_walltime                   = hiera('max_walltime', '80 * 60 * 60')
  $max_cputime                    = hiera('max_cputime', '80 * 60 * 60')

  $ganglia_cluster_name           = hiera('ganglia_cluster_name', undef)

  $uid_domain                     = hiera('uid_domain', 'example.org')
  $default_domain_name            = hiera('default_domain_name', $uid_domain)
  $filesystem_domain              = hiera('filesystem_domain', $::fqdn)

  $use_accounting_groups          = hiera('use_accounting_groups', false)
  $use_htcondor_account_mapping   = hiera('use_htcondor_account_mapping', true)

  # service security
  $condor_user                    = hiera('condor_user', root)
  $condor_group                   = hiera('condor_group', root)
  $condor_uid                     = hiera('condor_uid', 0)
  $condor_gid                     = hiera('condor_gid', 0)

  # authentication
  $use_fs_auth                    = hiera('use_fs_auth', true)
  $use_password_auth              = hiera('use_password_auth', true)
  $use_kerberos_auth              = hiera('use_kerberos_auth', false)
  $use_claim_to_be_auth           = hiera('use_claim_to_be_auth', false)
  $use_cert_map_file              = hiera('use_cert_map_file', false)
  $use_krb_map_file               = hiera('use_krb_map_file', false)
  $use_pid_namespaces             = hiera('use_pid_namespaces', false)
  $cert_map_file                  = hiera('cert_map_file', '/etc/condor/certificate_mapfile'
  )
  $certificate_mapfile            = hiera('certificate_mapfile', "puppet:///modules/${module_name}/certificate_mapfile"
  )
  $krb_map_file                   = hiera('krb_map_file', '/etc/condor/kerberos_mapfile'
  )
  $kerberos_mapfile               = hiera('kerberos_mapfile', "puppet:///modules/${module_name}/kerberos_mapfile"
  )
  $machine_list_prefix            = hiera('machine_list_prefix', 'condor_pool@$(UID_DOMAIN)/'
  )
  $pool_password_file             = hiera('pool_password_file', "puppet:///modules/${module_name}/pool_password"
  )

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
}
