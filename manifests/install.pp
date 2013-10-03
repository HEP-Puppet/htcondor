# Class htcondor::install
#
# Install HTCondor packages
class htcondor::install (
  $ensure = present,) {
  package { 'condor':
    ensure  => $ensure,
    require => [
      Yumrepo['htcondor-stable']],
  }
}
