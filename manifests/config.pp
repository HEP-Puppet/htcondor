# Class htcondor::config
#
# Configuration deployment for HTCondor
class htcondor::config (
  $is_worker   = false,
  $condor_host = $fqdn,
  $allow_write = [
    ]) {
  if $is_worker {
    $template = "${module_name}/condor_config_worker.local.erb"
  } else {
    $template = "${module_name}/condor_config_CE.local.erb"
  }

  file { '/etc/condor/condor_config.local':
    ensure  => present,
    backup  => ".bak",
    content => template($template),
    require => Package["condor"],
  # notify  => Service["condor"], this should be exec {'condor_reconfig':}
  }

}