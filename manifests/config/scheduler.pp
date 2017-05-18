# htcondor::config::scheduler
class htcondor::config::scheduler {
  include htcondor::config::security

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
  $daemon_list                = $htcondor::config::daemon_list
  # template files
  $template_ganglia           = $htcondor::template_ganglia
  $template_queues            = $htcondor::template_queues
  $template_resourcelimits    = $htcondor::template_resourcelimits
  $template_schedd            = $htcondor::template_schedd

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
