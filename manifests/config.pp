# Class htcondor::config
class htcondor::config {
  $enable_multicore     = $htcondor::enable_multicore
  $ganglia_cluster_name = $htcondor::ganglia_cluster_name
  $is_scheduler         = $htcondor::is_scheduler
  $is_remote_submit     = $htcondor::is_remote_submit
  $is_manager           = $htcondor::is_manager
  $is_worker            = $htcondor::is_worker
  $managers             = $htcondor::managers
  $use_shared_port      = $htcondor::use_shared_port
  $use_custom_logs      = $htcondor::use_custom_logs
  $use_debug_notify     = $htcondor::use_debug_notify

  # purge all non-managed config files from /etc/condor/config.d
  file { '/etc/condor/config.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  # files common between machines
  $common_class = 'htcondor::config::common'

  # SharedPort service configuration
  $sharedport_class = 'htcondor::config::sharedport'

  # Logging params configuration
  $logging_class = 'htcondor::config::logging'

  # Custom params configuration
  $custom_knobs_class = 'htcondor::config::custom_knobs'

  class { $common_class: }
  contain $common_class
  $more_than_two_managers = size($managers) > 1
  $run_ganglia            = $ganglia_cluster_name != undef

  $daemon_list            = create_daemon_list($is_worker, $is_scheduler,
  $is_manager, $enable_multicore, $run_ganglia, $more_than_two_managers)

  if $use_debug_notify {
    $debug_msg = "constructing daemon list from \n \
                  -is_worker: ${is_worker}\n \
                  -is_scheduler: ${is_scheduler}\n \
                  -is_remote_submit: ${is_remote_submit}\n \
                  -is_manager: ${is_manager}\n \
                  -enable_multicore: ${enable_multicore}\n \
                  -run_ganglia: ${run_ganglia} \n \
                  -more_than_two_managers: ${more_than_two_managers} \n\
                  resulting in ${daemon_list}"
    notify { 'checking daemon list:':
      withpath => true,
      name     => $debug_msg,
    }
  }

  if $use_custom_logs {
    class { $logging_class: }
    contain $logging_class
  }

  class { $custom_knobs_class: }
  contain $custom_knobs_class

  if $use_shared_port {
    class { $sharedport_class: }
    contain $sharedport_class
  }

  if $is_scheduler {
    class { 'htcondor::config::scheduler': }
    contain 'htcondor::config::scheduler'
  }

  if $is_remote_submit {
    class { 'htcondor::config::remote_submit': }
    contain 'htcondor::config::remote_submit'
  }

  if $is_manager {
    class { 'htcondor::config::manager': }
    contain 'htcondor::config::manager'
  }

  if $is_worker {
    class { 'htcondor::config::worker': }
    contain 'htcondor::config::worker'
  }
}
