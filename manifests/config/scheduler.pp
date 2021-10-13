# htcondor::config::scheduler
class htcondor::config::scheduler {
  # the get_htcondor metaknob will take of security configuration
  if ! $htcondor::condor_user::use_get_htcondor_metaknob {
    include htcondor::config::security
  }

  # general - manifest or 1 or more configs
  $condor_user                = $htcondor::condor_user
  $condor_group               = $htcondor::condor_group
  $ganglia_cluster_name       = $htcondor::ganglia_cluster_name
  # 12_resourcelimits.config
  $max_walltime               = $htcondor::max_walltime
  $max_cputime                = $htcondor::max_cputime
  $memory_factor              = $htcondor::memory_factor
  # /etc/condor/config.d/13_queues.config
  $queues                     = $htcondor::queues
  $periodic_expr_interval     = $htcondor::periodic_expr_interval
  $max_periodic_expr_interval = $htcondor::max_periodic_expr_interval
  $remove_held_jobs_after     = $htcondor::remove_held_jobs_after
  # /etc/condor/config.d/21_schedd.config
  $max_history_log            = $htcondor::max_history_log
  $max_history_rotations      = $htcondor::max_history_rotations
  $rotate_history_daily       = $htcondor::rotate_history_daily
  $log_to_syslog              = $htcondor::log_to_syslog
  $daemon_list                = $htcondor::config::daemon_list
  $schedd_blocked_users       = $htcondor::schedd_blocked_users
  $schedd_blocked_user_msg    = $htcondor::schedd_blocked_user_msg
  $job_default_requestcpus    = $htcondor::job_default_requestcpus
  $job_default_requestdisk    = $htcondor::job_default_requestdisk
  $job_default_requestmemory  = $htcondor::job_default_requestmemory
  # template files
  $template_ganglia           = $htcondor::template_ganglia
  $template_queues            = $htcondor::template_queues
  $template_resourcelimits    = $htcondor::template_resourcelimits
  $template_schedd            = $htcondor::template_schedd
  $template_metaknob_submit   = $htcondor::template_metaknob_submit

  if $htcondor::condor_user::use_get_htcondor_metaknob {
    file { '/etc/condor/config.d/01_metaknob_submit.config':
      content => template($template_metaknob_submit),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }
  file { '/etc/condor/config.d/12_resourcelimits.config':
    content => template($template_resourcelimits),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }

  if $queues {
    file { '/etc/condor/config.d/13_queues.config':
      content => template($template_queues),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }

  file { '/etc/condor/config.d/21_schedd.config':
    content => template($template_schedd),
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
}
