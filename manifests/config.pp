# Class htcondor::config
#
# Configuration deployment for HTCondor
#
# == Parameters:
#
# [*accounting_groups*]
# Accounting grous (and subgroups) for fair share configuration.
# Requires use_accounting_groups = true
# Default just provides an example for what needs to be specified
#
# [*cluster_has_multiple_domains*]
# Specifies if the cluster has more than one domain. If true it will set
# TRUST_UID_DOMAIN = True in 10_security.config
# Default: false
#
# [*collector_name*]
# Sets COLLECTOR_NAME in 22_manager.config
# Default: 'Personal Condor at $(FULL_HOSTNAME)'
#
# [*computing_elements*]
# List of CEs that have access to this HTCondor pool
#
# [*condor_admin_email*]
# Contact email for the pool admin. Sets CONDOR_ADMIN.
#
# [*custom_attribute*]
# Can be used to specify a ClassAd via custom_attribute = True. This is useful
# when creating queues with ARC CEs
# Default: NORDUGRID_QUEUE
#
# [*include_username_in_accounting*]
# Bool. If false the accounting groups used are of the form
# group_<group_name>.<subgroup>
# and if true
# group_<group_name>.<subgroup>.<user name>
#
# [*high_priority_groups*]
# A hash of groups with high priority. It is used for the group sorting
# expression for condor. Groups with lower value are considered first.
# example:
# $high_priority_groups = {
#                         'cms.admin' => -30,
#                         'ops'       => -20,
#                         'dteam'     => -10,
#                         }
# This will consider the group cms.admin first, followed by ops and dteam.
#
# [*is_ce*]
# If machine is a computing element or a scheduler (condor term)
#
# [*is_manager*]
# If machine is a manager or a negotiator (condor term)
#
# [*is_worker*]
# If the machine is a worker node
#
# [*machine_owner*]
# The owner of the machine (e.g. an accounting group)
#
# [*managers*]
# List of condor managers
#
# [*number_of_cpus*]
# Number of CPUs available for condor scheduling. This is set for worker nodes
# only
#
# [*pool_password*]
# Path to pool password file.
#
# [*uid_domain*]
# Condor UID_DOMAIN
# Default: example.com
#
# [*use_accounting_groups*]
# If accounting groups should be used (fair shares)
#
# [*worker_nodes*]
# List of worker nodes
#
class htcondor::config (
  $accounting_groups              = {
    'CMS'            => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.80,
    }
    ,
    'CMS.production' => {
      priority_factor => 10000.00,
      dynamic_quota   => 0.95,
    }
  }
  ,
  $cluster_has_multiple_domains   = false,
  $collector_name = 'Personal Condor at $(FULL_HOSTNAME)',
  $email_domain                   = 'localhost',
  $computing_elements             = [],
  $condor_admin_email             = 'root@mysite.org',
  $custom_attribute               = 'NORDUGRID_QUEUE',
  $high_priority_groups           = {
    'cms.admin' => -30,
    'ops'       => -20,
    'dteam'     => -10,
  }
  ,
  $include_username_in_accounting = false,
  $use_pkg_condor_config          = false,
  $is_ce          = false,
  $is_manager     = false,
  $is_worker      = false,
  $machine_owner  = 'physics',
  $managers       = [],
  $number_of_cpus = undef,
  $partitionable_slots = true,
  $request_memory = true,
  $use_kerberos_security = false,
  $certificate_mapfile = "puppet:///modules/${module_name}/certificate_mapfile",
  # pool_password can also be served from central file location using hiera
  $pool_password  = "puppet:///modules/${module_name}/pool_password",
  $pool_home      = '/pool',
  $uid_domain     = 'example.com',
  $default_domain_name = $uid_domain,
  $filesystem_domain = $uid_domain,
  $use_accounting_groups          = false,
  # specify the networks with write access i.e. ["10.132.0.*"]
  $worker_nodes   = [],
  
  $condor_user = root,
  $condor_group= root,
  $condor_uid  = 0,
  $condor_gid  = 0,
  
  #template selection. Allow for user to override
  $template_config_local    = "${module_name}/condor_config.local.erb",
  $template_security        = "${module_name}/10_security.config.erb",
  $template_resourcelimits  = "${module_name}/12_resourcelimits.config.erb",
  $template_schedd          = "${module_name}/21_schedd.config.erb",
  $template_fairshares      = "${module_name}/11_fairshares.config.erb",
  $template_manager         = "${module_name}/22_manager.config.erb",
  $template_workernode      = "${module_name}/20_workernode.config.erb",
  
  ) {
  $now                 = strftime('%d.%m.%Y_%H.%M')
  $ce_daemon_list      = ['SCHEDD']
  $worker_daemon_list  = ['STARTD']
  $manage_daemon_list  = ['COLLECTOR', 'NEGOTIATOR']
  # default daemon, runs everywhere
  $default_daemon_list = ['MASTER']
  $common_config_files = [
    File['/etc/condor/condor_config.local'],
    File['/etc/condor/config.d/10_security.config'],
    ]

  unless $use_pkg_condor_config {
    $condor_main_config = [ File['/etc/condor/condor_config'] ]
    $common_config_files = concat($condor_main_config, $common_config_files)
  }
  
  if $is_ce and $is_manager {
    # machine is both CE and manager (for small sites)
    $temp_list               = concat($default_daemon_list, $ce_daemon_list)
    $daemon_list             = concat($temp_list, $manage_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      File['/etc/condor/config.d/22_manager.config'],
      ]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_ce {
    $daemon_list             = concat($default_daemon_list, $ce_daemon_list)
    $additional_config_files = [
      File['/etc/condor/config.d/12_resourcelimits.config'],
      File['/etc/condor/config.d/21_schedd.config'],
      ]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_manager {
    # machine running only manager
    $daemon_list             = concat($default_daemon_list, $manage_daemon_list)
    $additional_config_files = [File['/etc/condor/config.d/22_manager.config'],]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } elsif $is_worker {
    $daemon_list             = concat($default_daemon_list, $worker_daemon_list)
    $additional_config_files = [File['/etc/condor/config.d/20_workernode.config'
        ],]
    $config_files            = concat($common_config_files,
    $additional_config_files)
  } else {
    $daemon_list  = $default_daemon_list
    $config_files = $common_config_files
  }

  # files common between machines
  unless $use_pkg_condor_config {
    file { '/etc/condor/condor_config':
      backup  => ".bak.${now}",
      source  => "puppet:///modules/${module_name}/condor_config",
      require => Package['condor'],
      owner => $condor_user,
      group => $condor_group,
      mode => 644,
    }
  }

  file { '/etc/condor/condor_config.local':
    backup  => ".bak.${now}",
    content => template($template_config_local),
    require => Package['condor'],
    owner => $condor_user,
    group => $condor_group,
    mode => 644,
  }

  file { '/etc/condor/config.d/10_security.config':
    content => template($template_security),
    require => Package['condor'],
    owner => $condor_user,
    group => $condor_group,
    mode => 644,
  }

  file { ["${pool_home}", "${pool_home}/condor", "/etc/condor/persistent"]:
    ensure => directory,
    owner  => 'condor',
    mode => 644,
  }

  if $use_kerberos_security {
      file { '/etc/condor/certificate_mapfile':
        ensure => present,
        source => $certificate_mapfile,
        owner => $condor_user,
        group => $condor_group,
      }
  } else {
      #even if condor runs as condor, it just drops privileges and needs to start as root.
      #if file is not owned by root, condor will throw this error :
      #06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real uid
      #06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real uid
      file { '/etc/condor/pool_password':
        ensure => present,
        source => $pool_password,
        owner => root,
        group => root,
        mode => 640,
      }
  }

  # files for certain roles
  if $is_ce {
    file { '/etc/condor/config.d/12_resourcelimits.config':
      content => template($template_resourcelimits),
      require => Package['condor'],
      owner => $condor_user,
      group => $condor_group,
      mode => 644,
    }

    file { '/etc/condor/config.d/21_schedd.config':
      content => template($template_schedd),
      require => Package['condor'],
      owner => $condor_user,
      group => $condor_group,
      mode => 644,
    }

  }

  if $is_manager {
    if $use_accounting_groups {
      file { '/etc/condor/config.d/11_fairshares.config':
        content => template($template_fairshares),
        require => Package['condor'],
        owner => $condor_user,
        group => $condor_group,
        mode => 644,
      }
    }

    file { '/etc/condor/config.d/22_manager.config':
      content => template($template_manager),
      require => Package['condor'],
      owner => $condor_user,
      group => $condor_group,
      mode => 644,
    }
    # TODO: high availability
    # TODO: defrag
  }

  if $is_worker {
    file { '/etc/condor/config.d/20_workernode.config':
      content => template($template_workernode),
      require => Package['condor'],
      owner => $condor_user,
      group => $condor_group,
      mode => 644,
    }
  }
}
