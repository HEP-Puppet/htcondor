# @summary Configure HTCondor logging
#
# This class configures HTCondor logging.
#
# @example Configure HTCondor logging
#
#   class { 'htcondor::config::logging':
#     log_to_syslog      => 'Daemon',
#     logging_parameters => {
#       'D_FULLDEBUG' => 'D_ALWAYS',
#     },
#     template_logging   => 'htcondor/logging.config.erb',
#     condor_user        => 'condor',
#     condor_group       => 'condor',
#   }
#
# @param log_to_syslog
#   The value of the `LOG_TO_SYSLOG` configuration parameter.
#   Defaults to `Daemon`.
#
# @param logging_parameters
#   A hash of configuration parameters to set in the `LOGGING` configuration
#   parameter.
#   Defaults to `{}`.
#
# @param template_logging
#   The path to the template to use for the `14_logging.config` file.
#   Defaults to `htcondor/logging.config.erb`.
#
# @param condor_user
#   The user that owns the HTCondor configuration files.
#   Defaults to `condor`.
#
# @param condor_group
#   The group that owns the HTCondor configuration files.
#   Defaults to `condor`.
#
class htcondor::config::logging (
  Optional[String] $log_to_syslog      = $htcondor::log_to_syslog,
  Optional[Hash] $logging_parameters = $htcondor::logging_parameters,
  Optional[String] $template_logging   = $htcondor::template_logging,
  Optional[String] $condor_user        = $htcondor::condor_user,
  Optional[String] $condor_group       = $htcondor::condor_group,
) {
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
