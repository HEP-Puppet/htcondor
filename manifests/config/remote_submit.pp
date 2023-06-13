# @summary
# htcondor::config::remote_submit to configure passive nodes dedicated to user login and submission
class htcondor::config::remote_submit {
  $condor_user                = $htcondor::condor_user
  $condor_group               = $htcondor::condor_group

  include htcondor::config::security

  file { '/etc/condor/config.d/19_remote_submit.config':
    content => 'DAEMON_LIST = ""',
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
  }
}
