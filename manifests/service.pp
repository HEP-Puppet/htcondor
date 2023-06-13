# == Class: htcondor::service
# @summary Starts the services for HTCondor
#
class htcondor::service {
  $is_remote_submit = $htcondor::is_remote_submit
  $service_state = $is_remote_submit ? { true => 'stopped', default => 'running' }

  # Remote submit nodes don't have running service
  service { 'condor':
    ensure     => $service_state,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  # this exec is called from the config, but we can't run it if the condor
  # service is not up. it's a RE-config command assuming something is already up.
  exec { '/usr/sbin/condor_reconfig':
    refreshonly => true,
    path        => '/usr/bin:/usr/sbin:/bin',
    unless      => 'test -f /etc/condor/config.d/19_remote_submit.config',
    require     => Service['condor'],
  }
}
