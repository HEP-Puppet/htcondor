# A config file for custom parameters not managed anywhere else
class htcondor::config::custom_knobs(
  $custom_knobs          = $htcondor::custom_knobs,
  $template_custom_knobs = $htcondor::template_custom_knobs,
  $condor_user           = $htcondor::condor_user,
  $condor_group          = $htcondor::condor_group,
)
{
  if $custom_knobs != {} {
    file { '/etc/condor/config.d/60_custom_knobs.config':
      content => template($template_custom_knobs),
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }
}

# vim: ft=puppet
