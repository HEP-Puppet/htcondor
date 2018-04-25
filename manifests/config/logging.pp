#
class htcondor::config::logging(
  $log_to_syslog    = $htcondor::log_to_syslog,
  $template_logging = $htcondor::template_logging,
  $condor_user      = $htcondor::condor_user,
  $condor_group     = $htcondor::condor_group,
)
{

  file { '/etc/condor/config.d/14_logging.config':
    content => template($template_logging),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }
}

# vim: ft=puppet
