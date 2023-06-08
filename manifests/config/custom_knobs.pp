# @summary A config file for custom parameters not managed anywhere else
#
# @param custom_knobs
#   A hash of custom parameters to set
# @param template_custom_knobs
#   The template to use for the custom_knobs file. Defaults to undef.
# @param condor_user
#   The user that condor runs as. Defaults to 'condor'.
# @param condor_group
#   The group that condor runs as. Defaults to 'condor'.
#
class htcondor::config::custom_knobs (
  Hash $custom_knobs,
  Optional[String] $template_custom_knobs = undef,
  Optional[String] $condor_user = $htcondor::condor_user,
  Optional[String] $condor_group = $htcondor::condor_group,
) {
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
