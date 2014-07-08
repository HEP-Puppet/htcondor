# Class htcondor::service
#
# Starts the services for HTCondor
class htcondor::service {
  service { 'condor':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  exec { '/usr/sbin/condor_reconfig':
    subscribe   => $htcondor::config::config_files,
    refreshonly => true,
  }

  Service['condor'] -> Exec['/usr/sbin/condor_reconfig']
}
