# Configuration of Condor SharedPort service
class htcondor::config::sharedport {
  $use_shared_port            = $htcondor::use_shared_port
  $shared_port                = $htcondor::shared_port
  $shared_port_collector_name = $htcondor::shared_port_collector_name

  $template_sharedport        = $htcondor::template_sharedport
  $managers                   = $htcondor::managers

  $condor_user                = $htcondor::condor_user
  $condor_group               = $htcondor::condor_group

  $now                        = strftime('%d.%m.%Y_%H.%M')

  # SharedPort service configuration
  file { '/etc/condor/config.d/42_shared_port.config':
    backup  => ".bak.${now}",
    content => template($template_sharedport),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }
}
