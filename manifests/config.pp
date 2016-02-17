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
  $more_than_two_managers = size($managers) > 1
  $run_ganglia            = $ganglia_cluster_name != undef

  $daemon_list            = create_daemon_list($is_worker, $is_scheduler,
  $is_manager, $enable_multicore, $run_ganglia, $more_than_two_managers)

  $debug_msg = "constructing daemon list from \n \
                -is_worker: ${is_worker}\n \
                -is_scheduler: ${is_scheduler}\n \
                -is_manager: ${is_manager}\n \
                -enable_multicore: ${enable_multicore}\n \
                -run_ganglia: ${run_ganglia} \n \
                -more_than_two_managers: ${more_than_two_managers} \n\
                resulting in ${daemon_list}"
  notify { 'checking daemon list:':
    withpath => true,
    name     => $debug_msg,
  }

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
