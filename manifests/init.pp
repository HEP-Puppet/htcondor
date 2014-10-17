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
#
# Templates parameters : these parameters allow for user to override the default
# templates, for their needs, ie for instance for a different fairshare
#
#  $template_config_local
#  $template_security
#  $template_resourcelimits
#  $template_schedd
#  $template_fairshares
#  $template_manager
#  $template_workernode
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
class htcondor (
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
  $collector_name                 = 'Personal Condor at $(FULL_HOSTNAME)',
  $email_domain                   = 'localhost',
  $computing_elements             = [],
  $condor_admin_email             = 'root@mysite.org',
  $condor_priority                = '99',
  $condor_version                 = 'present',
  $custom_attribute               = 'NORDUGRID_QUEUE',
  $enable_multicore               = false,
  $enable_healthcheck             = false,
  $high_priority_groups           = {
    'cms.admin' => -30,
    'ops'       => -20,
    'dteam'     => -10,
  }
  ,
  $priority_halflife              = 43200,
  $default_prio_factor            = 100000.00,
  $group_accept_surplus           = true,
  $group_autoregroup              = true,
  $health_check_script            = "puppet:///modules/${module_name}/healhcheck_wn_condor",
  $include_username_in_accounting = false,
  $use_pkg_condor_config          = false,
  $install_repositories           = true,
  $dev_repositories               = false,
  $is_ce                          = false,
  $is_manager                     = false,
  $is_worker                      = false,
  $machine_owner                  = 'physics',
  $managers                       = [],
  $number_of_cpus                 = undef,
  $partitionable_slots            = true,
  $memory_overcommit              = 1.5,
  $request_memory                 = true,
  $certificate_mapfile            = "puppet:///modules/${module_name}/certificate_mapfile",
  $pool_home                      = '/pool',
  $pool_create                    = true,
  $queues                         = hiera('grid_queues', undef),
  $periodic_expr_interval         = 60,
  $max_periodic_expr_interval     = 1200,
  $remove_held_jobs_after         = 1200,
  $leave_job_in_queue             = undef,
  $ganglia_cluster_name           = false,
  $pool_password                  = "puppet:///modules/${module_name}/pool_password",
  $uid_domain                     = 'example.com',
  $default_domain_name            = $uid_domain,
  $filesystem_domain              = $uid_domain,
  $use_accounting_groups          = false,
  $worker_nodes                   = [],
  # default params
  $condor_user                    = root,
  $condor_group                   = root,
  $condor_uid                     = 0,
  $condor_gid                     = 0,
  # template selection. Allow for user to override
  $template_config_local          = "${module_name}/condor_config.local.erb",
  $template_security              = "${module_name}/10_security.config.erb",
  $template_resourcelimits        = "${module_name}/12_resourcelimits.config.erb",
  $template_queues                = "${module_name}/13_queues.config.erb",
  $template_schedd                = "${module_name}/21_schedd.config.erb",
  $template_fairshares            = "${module_name}/11_fairshares.config.erb",
  $template_manager               = "${module_name}/22_manager.config.erb",
  $template_ganglia               = "${module_name}/23_ganglia.config.erb",
  $template_workernode            = "${module_name}/20_workernode.config.erb",
  $template_defrag                = "${module_name}/33_defrag.config.erb",
  $use_claim_to_be_security       = false,
  $use_filesystem_security        = true,
  $use_kerberos_security          = false,
  $use_password_security          = true,
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
    collector_name                 => $collector_name,
    email_domain                   => $email_domain,
    computing_elements             => $computing_elements,
    condor_admin_email             => $condor_admin_email,
    custom_attribute               => $custom_attribute,
    enable_multicore               => $enable_multicore,
    enable_healthcheck             => $enable_healthcheck,
    high_priority_groups           => $high_priority_groups,
    priority_halflife              => $priority_halflife,
    default_prio_factor            => $default_prio_factor,
    group_accept_surplus           => $group_accept_surplus,
    group_autoregroup              => $group_autoregroup,
    health_check_script            => $health_check_script,
    include_username_in_accounting => $include_username_in_accounting,
    use_pkg_condor_config          => $use_pkg_condor_config,
    is_ce                          => $is_ce,
    is_manager                     => $is_manager,
    is_worker                      => $is_worker,
    machine_owner                  => $machine_owner,
    managers                       => $managers,
    number_of_cpus                 => $number_of_cpus,
    partitionable_slots            => $partitionable_slots,
    memory_overcommit              => $memory_overcommit,
    request_memory                 => $request_memory,
    certificate_mapfile            => $certificate_mapfile,
    pool_home                      => $pool_home,
    queues                         => $queues,
    periodic_expr_interval         => $periodic_expr_interval,
    max_periodic_expr_interval     => $max_periodic_expr_interval,
    remove_held_jobs_after         => $remove_held_jobs_after,
    leave_job_in_queue             => $leave_job_in_queue,
    ganglia_cluster_name           => $ganglia_cluster_name,
    pool_password                  => $pool_password,
    pool_create                    => $pool_create,
    uid_domain                     => $uid_domain,
    default_domain_name            => $default_domain_name,
    filesystem_domain              => $filesystem_domain,
    use_accounting_groups          => $use_accounting_groups,
    worker_nodes                   => $worker_nodes,
    condor_user                    => $condor_user,
    condor_group                   => $condor_group,
    condor_uid                     => $condor_uid,
    condor_gid                     => $condor_gid,
    # template selection. Allow for user to override
    template_config_local          => $template_config_local,
    template_security              => $template_security,
    template_resourcelimits        => $template_resourcelimits,
    template_queues                => $template_queues,
    template_schedd                => $template_schedd,
    template_fairshares            => $template_fairshares,
    template_manager               => $template_manager,
    template_workernode            => $template_workernode,
    template_ganglia               => $template_ganglia,
    template_defrag                => $template_defrag,
    use_claim_to_be_security       => $use_claim_to_be_security,
    use_filesystem_security        => $use_filesystem_security,
    use_kerberos_security          => $use_kerberos_security,
    use_password_security          => $use_password_security,
  }

  class { 'htcondor::service':
  }

  Class['htcondor::repositories'] -> Class['htcondor::install'] -> Class['htcondor::config'
    ] -> Class['htcondor::service']
}
