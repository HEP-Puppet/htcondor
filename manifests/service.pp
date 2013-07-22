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
}