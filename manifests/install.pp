# Class htcondor::install
#
# Install HTCondor packages
class htcondor::install (
  $ensure = present,
  $dev_repos = false,) {
  if $dev_repos {
    $repo = 'htcondor-development'
  } else {
    $repo = 'htcondor-stable'
  }
  package { 'condor':
    ensure  => $ensure,
  }
}
