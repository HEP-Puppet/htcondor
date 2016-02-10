# Class htcondor::config
class htcondor::config {
  $enable_multicore     = $htcondor::enable_multicore
  $ganglia_cluster_name = $htcondor::ganglia_cluster_name
  $is_scheduler         = $htcondor::is_scheduler
  $is_manager           = $htcondor::is_manager
  $is_worker            = $htcondor::is_worker
  $managers             = $htcondor::managers

  # purge all non-managed config files from /etc/condor/config.d
  file { '/etc/condor/config.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  # files common between machines
  $common_class = 'htcondor::config::common'

  class { $common_class: }

  $daemon_list = create_daemon_list($is_worker, $is_scheduler, $is_manager,
  $enable_multicore, $ganglia_cluster_name, size($managers) > 1)

  if $is_scheduler {
    class { 'htcondor::config::scheduler': require => Class[$common_class], }
  }

  if $is_manager {
    class { 'htcondor::config::manager': require => Class[$common_class], }
  }

  if $is_worker {
    class { 'htcondor::config::worker': require => Class[$common_class], }
  }

}
