# Class htcondor::install
#
# Install HTCondor packages
class htcondor::install {
  $package_ensure  = $htcondor::condor_version

  $_package_ensure = $package_ensure ? {
    true     => 'present',
    false    => 'purged',
    'absent' => 'purged',
    default  => $package_ensure,
  }

  package { 'condor': ensure => $_package_ensure, }
}
