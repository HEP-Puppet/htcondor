# htcondor::config::scheduler
class htcondor::config::worker {
  include htcondor::config::security

  # general - manifest or 1 or more configs
  $condor_user               = $htcondor::condor_user
  $condor_group              = $htcondor::condor_group
  $health_check_script       = $htcondor::health_check_script
  # /etc/condor/config.d/20_workernode.config
  $custom_machine_attributes = $htcondor::custom_machine_attributes
  $custom_job_attributes     = $htcondor::custom_job_attributes
  $daemon_list               = $htcondor::config::daemon_list
  $enable_cgroup             = $htcondor::enable_cgroup
  $enable_healthcheck        = $htcondor::enable_healthcheck
  $machine_owner             = $htcondor::machine_owner
  $memory_overcommit         = $htcondor::memory_overcommit
  $number_of_cpus            = $htcondor::number_of_cpus
  $partitionable_slots       = $htcondor::partitionable_slots
  $pool_create               = $htcondor::pool_create
  $pool_home                 = $htcondor::pool_home
  $use_pid_namespaces        = $htcondor::use_pid_namespaces
  # template files
  $template_workernode       = $htcondor::template_workernode

  file { '/etc/condor/config.d/20_workernode.config':
    content => template($template_workernode),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }

  file { '/usr/local/bin/healhcheck_wn_condor':
    source => $health_check_script,
    owner  => $condor_user,
    group  => $condor_group,
    mode   => '0655',
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
}
