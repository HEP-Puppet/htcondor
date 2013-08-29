# Class htcondor::config
#
# Configuration deployment for HTCondor
class htcondor::config (
  $is_worker          = false,
  $is_ce              = false,
  $is_manager         = false,
  $condor_host        = $fqdn,
  $condor_admin_email = 'root@mysite.org',
  $collector_name     = 'Personal Condor at $(FULL_HOSTNAME)',
  $machine_owner      = 'physics',
  $number_of_cpus     = 8,
  # specify the networks with write access i.e. ["10.132.0.*"]
  $allow_write        = []) {
  $now                 = strftime('%d.%m.%Y_%H.%M')
  $ce_daemon_list      = ['SCHEDD']
  $worker_daemon_list  = ['STARTD']
  $manage_daemon_list  = [
    'COLLECTOR',
    'NEGOTIATOR']

  # default daemon, runs everywhere
  $default_daemon_list = ['MASTER']

  if $is_ce and $is_manager {
    # machine is both CE and manager (for small sites)
    $temp_list   = concat($default_daemon_list, $ce_daemon_list)
    $daemon_list = concat($temp_list, $manage_daemon_list)
  } elsif $is_ce {
    $daemon_list = concat($default_daemon_list, $ce_daemon_list)
  } elsif $is_worker {
    $daemon_list = concat($default_daemon_list, $worker_daemon_list)
  } else {
    $daemon_list = $default_daemon_list
  }

  # files common between machines
  file { '/etc/condor/condor_config':
    backup  => ".bak.${now}",
    source  => "puppet:///modules/${module_name}/condor_config",
    require => Package['condor'],
  }

  file { '/etc/condor/condor_config.local':
    backup  => ".bak.${now}",
    content => "CONDOR_ADMIN = $condor_admin_email",
    require => Package['condor'],
  # notify  => Service["condor"], this should be exec {'condor_reconfig':}
  }

  file { '/etc/condor/persistent': ensure => directory, }

  # files for certain roles

  if $is_ce {
    file { '/etc/condor/condor.d/12_resourcelimits.config':
      backup  => ".bak.${now}",
      source  => "puppet:///modules/${module_name}/12_resourcelimits.config",
      require => Package['condor'],
    }

    file { '/etc/condor/condor.d/21_schedd.config':
      backup  => ".bak.${now}",
      content => template("${module_name}/21_schedd.config.erb"),
      require => Package['condor'],
    }
  }

  if $is_manager {
    # TODO: fair shares
    file { '/etc/condor/condor.d/22_manager.config':
      backup  => ".bak.${now}",
      content => template("${module_name}/21_schedd.config.erb"),
      require => Package['condor'],
    }
    # TODO: high availability
    # TODO: defrag
  }

  if $is_worker {
    file { '/etc/condor/condor.d/20_workernode.config':
      backup  => ".bak.${now}",
      content => template("${module_name}/20_workernode.config.erb"),
      require => Package['condor'],
    }
  }

}