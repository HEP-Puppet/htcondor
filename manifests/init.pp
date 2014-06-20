# Class: htcondor
#
# This module manages htcondor
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
# [*include_username_in_accounting*]
# Bool. If false the accounting groups used are of the form
# group_<group_name>.<subgroup>
# and if true
# group_<group_name>.<subgroup>.<user name>
#
# [*install_repositories*]
# Bool to install repositories or not
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
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
class htcondor (
  $accounting_groups     = {
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
  $collector_name        = 'Personal Condor at $(FULL_HOSTNAME)',
  $computing_elements    = [],
  $condor_admin_email    = 'root@mysite.org',
  $condor_priority       = '99',
  $condor_version        = 'present',
  $custom_attribute      = 'NORDUGRID_QUEUE',
  $high_priority_groups  = {
    'cms.admin' => -30,
    'ops'       => -20,
    'dteam'     => -10,
  }
  ,
  $include_username_in_accounting = false,
  $install_repositories  = true,
  $dev_repositories      = false,
  $use_pkg_condor_config = false,
  $is_ce                 = false,
  $is_manager            = false,
  $is_worker             = false,
  $machine_owner         = 'physics',
  $managers              = [],
  $number_of_cpus        = undef,
  $use_gsi_kerberos_security = false,
  $certificate_mapfile   = "puppet:///modules/${caller_module_name}/certificate_mapfile",
  $pool_home             = '/pool',
  $pool_password         = "puppet:///modules/${module_name}/pool_password",
  $uid_domain            = 'example.com',
  $use_accounting_groups = false,
  $worker_nodes          = [],
  
  #default params
  $condor_user = root,
  $condor_group= root,
  $condor_uid  = 0,
  $condor_gid  = 0,
  
  ) {
  class { 'htcondor::repositories':
    install_repos   => $install_repositories,
    dev_repos       => $dev_repositories,
    condor_priority => $condor_priority,
  }

  class { 'htcondor::install':
    ensure    => $condor_version,
    dev_repos => $dev_repositories,
  }

  class { 'htcondor::config':
    accounting_groups              => $accounting_groups,
    cluster_has_multiple_domains   => $cluster_has_multiple_domains,
    collector_name => $collector_name,
    computing_elements             => $computing_elements,
    condor_admin_email             => $condor_admin_email,
    custom_attribute               => $custom_attribute,
    high_priority_groups           => $high_priority_groups,
    include_username_in_accounting => $include_username_in_accounting,
    use_pkg_condor_config          => $use_pkg_condor_config,
    is_ce          => $is_ce,
    is_manager     => $is_manager,
    is_worker      => $is_worker,
    machine_owner  => $machine_owner,
    managers       => $managers,
    number_of_cpus => $number_of_cpus,
    use_gsi_kerberos_security => $use_gsi_kerberos_security,
    certificate_mapfile => $certificate_mapfile,
    pool_home      => $pool_home,
    pool_password  => $pool_password,
    uid_domain     => $uid_domain,
    use_accounting_groups          => $use_accounting_groups,
    worker_nodes   => $worker_nodes,
    condor_user => $condor_user,
    condor_group=> $condor_group,
    condor_uid  => $condor_uid,
    condor_gid  => $condor_gid,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'
    ] -> Class['htcondor::service']
}
