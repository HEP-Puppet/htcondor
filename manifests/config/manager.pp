# htcondor::config::manager
class htcondor::config::manager {
  include htcondor::config::security
  # general - manifest or 1 or more configs
  $condor_user                     = $htcondor::condor_user
  $condor_group                    = $htcondor::condor_group
  $enable_multicore                = $htcondor::enable_multicore
  $ganglia_cluster_name            = $htcondor::ganglia_cluster_name
  $managers                        = $htcondor::managers
  $use_accounting_groups           = $htcondor::use_accounting_groups
  # /etc/condor/config.d/11_fairshares.config
  $accounting_groups               = $htcondor::accounting_groups
  $default_prio_factor             = $htcondor::default_prio_factor
  $group_accept_surplus            = $htcondor::group_accept_surplus
  $group_autoregroup               = $htcondor::group_autoregroup
  $high_priority_groups            = $htcondor::high_priority_groups
  $priority_halflife               = $htcondor::priority_halflife
  # /etc/condor/config.d/22_manager.config
  $collector_name                  = $htcondor::collector_name
  $collector_query_workers         = $htcondor::collector_query_workers
  $collector_max_file_descriptors  = $htcondor::collector_max_file_descriptors
  $daemon_list                     = $htcondor::config::daemon_list
  # /etc/condor/config.d/33_defrag.config
  $defrag_interval                 = $htcondor::defrag_interval
  $defrag_draining_machines_per_hr = $htcondor::defrag_draining_machines_per_hr
  $defrag_max_concurrent_draining  = $htcondor::defrag_max_concurrent_draining
  $defrag_max_whole_machines       = $htcondor::defrag_max_whole_machines
  $defrag_schedule                 = $htcondor::defrag_schedule
  $defrag_rank                     = $htcondor::defrag_rank
  $whole_machine_cpus              = $htcondor::whole_machine_cpus
  $defrag_requirements             = $htcondor::defrag_requirements
  $log_to_syslog                   = $htcondor::log_to_syslog
  # template files
  $template_defrag                 = $htcondor::template_defrag
  $template_fairshares             = $htcondor::template_fairshares
  $template_ganglia                = $htcondor::template_ganglia
  $template_ha                     = $htcondor::template_highavailability
  $template_manager                = $htcondor::template_manager

  if $use_accounting_groups {
    file { '/etc/condor/config.d/11_fairshares.config':
      content => template($template_fairshares),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }

  file { '/etc/condor/config.d/22_manager.config':
    content => template($template_manager),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }

  if $ganglia_cluster_name {
    file { '/etc/condor/config.d/23_ganglia.config':
      content => template($template_ganglia),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }

  if $enable_multicore {
    file { '/etc/condor/config.d/33_defrag.config':
      content => template($template_defrag),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }

  if size($managers) > 1 {
    $replication_machines = suffix($managers, ':$(REPLICATION_PORT)')
    $had_machines         = suffix($managers, ':$(HAD_PORT)')
    $replication_list     = join($replication_machines, ', ')
    $had_list             = join($had_machines, ', ')

    file { '/etc/condor/config.d/30_highavailability.config':
      content => template($template_ha),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }
}
