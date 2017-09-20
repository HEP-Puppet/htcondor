# Class: htcondor
#
# This module manages htcondor. Parameters that refer to condor 'knobs' (e.g.
# CONDOR_ADMIN) will not be explained here.
# Instead please refer to the HTCondor documentation:
# http://research.cs.wisc.edu/htcondor/manual/latest/3_3Configuration.html
#
# Defaults for the parameters can be found in htcondor::params
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
#
# [*collector_name*]
# Sets COLLECTOR_NAME in 22_manager.config
# Default: 'Personal Condor at $(FULL_HOSTNAME)'
#
# [*schedulers*]
# List of schedulers that are allowed to submit jobs to the HTCondor pool
#
# [*admin_email*]
# Sets CONDOR_ADMIN
# (http://research.cs.wisc.edu/htcondor/manual/latest/3_3Configuration.html).
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
# [*$is_scheduler*]
# If current machine is a condor scheduler
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
  $accounting_groups              = $htcondor::params::accounting_groups,
  $cluster_has_multiple_domains   =
  $htcondor::params::cluster_has_multiple_domains,
  $collector_name                 = $htcondor::params::collector_name,
  $email_domain                   = $htcondor::params::email_domain,
  $schedulers                     = $htcondor::params::schedulers,
  $admin_email                    = $htcondor::params::admin_email,
  $condor_priority                = $htcondor::params::repo_priority,
  $condor_version                 = $htcondor::params::condor_version,
  $custom_machine_attributes      = $htcondor::params::custom_machine_attributes,
  $custom_job_attributes          = $htcondor::params::custom_job_attributes,
  $use_debug_notify               = $htcondor::params::use_debug_notify,
  $enable_condor_reporting        = $htcondor::params::enable_condor_reporting,
  $enable_cgroup                  = $htcondor::params::enable_cgroup,
  $enable_multicore               = $htcondor::params::enable_multicore,
  $enable_healthcheck             = $htcondor::params::enable_healthcheck,
  $htcondor_cgroup                = $htcondor::params::htcondor_cgroup,
  $high_priority_groups           = $htcondor::params::high_priority_groups,
  $priority_halflife              = $htcondor::params::priority_halflife,
  $default_prio_factor            = $htcondor::params::default_prio_factor,
  $group_accept_surplus           = $htcondor::params::group_accept_surplus,
  $group_autoregroup              = $htcondor::params::group_autoregroup,
  $health_check_script            = $htcondor::params::health_check_script,
  $include_username_in_accounting =
  $htcondor::params::include_username_in_accounting,
  $install_repositories           = $htcondor::params::install_repositories,
  $dev_repositories               = $htcondor::params::dev_repositories,
  $is_scheduler                   = $htcondor::params::is_scheduler,
  $is_manager                     = $htcondor::params::is_manager,
  $is_worker                      = $htcondor::params::is_worker,
  $machine_owner                  = $htcondor::params::machine_owner,
  $managers                       = $htcondor::params::managers,
  $number_of_cpus                 = $htcondor::params::number_of_cpus,
  $partitionable_slots            = $htcondor::params::partitionable_slots,
  $memory_overcommit              = $htcondor::params::memory_overcommit,
  $request_memory                 = $htcondor::params::request_memory,
  $certificate_mapfile            = $htcondor::params::certificate_mapfile,
  $kerberos_mapfile               = $htcondor::params::kerberos_mapfile,
  $starter_job_environment        = $htcondor::params::starter_job_environment,
  $pool_home                      = $htcondor::params::pool_home,
  $pool_create                    = $htcondor::params::pool_create,
  $mount_under_scratch_dirs       = $htcondor::params::mount_under_scratch_dirs,
  $queues                         = $htcondor::params::queues,
  $periodic_expr_interval         = $htcondor::params::periodic_expr_interval,
  $max_periodic_expr_interval     =
  $htcondor::params::max_periodic_expr_interval,
  $remove_held_jobs_after         = $htcondor::params::remove_held_jobs_after,
  $leave_job_in_queue             = $htcondor::params::leave_job_in_queue,
  $ganglia_cluster_name           = $htcondor::params::ganglia_cluster_name,
  $pool_password                  = $htcondor::params::pool_password_file,
  $uid_domain                     = $htcondor::params::uid_domain,
  $default_domain_name            = $htcondor::params::default_domain_name,
  $filesystem_domain              = $htcondor::params::filesystem_domain,
  $use_accounting_groups          = $htcondor::params::use_accounting_groups,
  $workers                        = $htcondor::params::workers,
  # default params
  $condor_user                    = root,
  $condor_group                   = root,
  $condor_uid                     = 0,
  $condor_gid                     = 0,
  # template selection. Allow for user to override
  $template_config_local          = $htcondor::params::template_config_local,
  $template_security              = $htcondor::params::template_security,
  $template_resourcelimits        = $htcondor::params::template_resourcelimits,
  $template_queues                = $htcondor::params::template_queues,
  $template_schedd                = $htcondor::params::template_schedd,
  $template_fairshares            = $htcondor::params::template_fairshares,
  $template_manager               = $htcondor::params::template_manager,
  $template_ganglia               = $htcondor::params::template_ganglia,
  $template_workernode            = $htcondor::params::template_workernode,
  $template_defrag                = $htcondor::params::template_defrag,
  $template_sharedport            = $htcondor::params::template_sharedport,
  $template_singularity           = $htcondor::params::template_singularity,
  $template_highavailability      =
  $htcondor::params::template_highavailability,
  $use_htcondor_account_mapping   =
  $htcondor::params::use_htcondor_account_mapping,
  $use_anonymous_auth             = $htcondor::params::use_anonymous_auth,
  $use_fs_auth                    = $htcondor::params::use_fs_auth,
  $use_password_auth              = $htcondor::params::use_password_auth,
  $use_kerberos_auth              = $htcondor::params::use_kerberos_auth,
  $use_claim_to_be_auth           = $htcondor::params::use_claim_to_be_auth,
  $use_cert_map_file              = $htcondor::params::use_cert_map_file,
  $use_krb_map_file               = $htcondor::params::use_krb_map_file,
  $use_ssl_auth                   = $htcondor::params::use_ssl_auth,
  $use_pid_namespaces             = $htcondor::params::use_pid_namespaces,
  $uses_connection_broker         = $htcondor::params::uses_connection_broker,
  $private_network_name           = $htcondor::params::private_network_name,
  $cert_map_file                  = $htcondor::params::cert_map_file,
  $cert_map_file_source           = $htcondor::params::cert_map_file_source,
  $krb_map_file                   = $htcondor::params::krb_map_file,
  $krb_map_file_source            = $htcondor::params::krb_map_file_source,
  $ssl_server_keyfile             = $htcondor::params::ssl_server_keyfile,
  $ssl_client_keyfile             = $htcondor::params::ssl_client_keyfile,
  $ssl_server_certfile            = $htcondor::params::ssl_server_certfile,
  $ssl_client_certfile            = $htcondor::params::ssl_client_certfile,
  $ssl_server_cafile              = $htcondor::params::ssl_server_cafile,
  $ssl_client_cafile              = $htcondor::params::ssl_client_cafile,
  $ssl_server_cadir               = $htcondor::params::ssl_server_cadir,
  $ssl_client_cadir               = $htcondor::params::ssl_client_cadir,
  $machine_list_prefix            = $htcondor::params::machine_list_prefix,
  $max_walltime                   = $htcondor::params::max_walltime,
  $max_cputime                    = $htcondor::params::max_cputime,
  $memory_factor                  = $htcondor::params::memory_factor,
  $use_shared_port                = $htcondor::params::use_shared_port,
  $shared_port                    = $htcondor::params::shared_port,
  $shared_port_collector_name     = $htcondor::params::shared_port_collector_name,
  $use_singularity                = $htcondor::params::use_singularity,
  $singularity_path               = $htcondor::params::singularity_path,
  $force_singularity_jobs         = $htcondor::params::force_singularity_jobs,
  $singularity_image_expr         = $htcondor::params::singularity_image_expr,
  $singularity_bind_paths         = $htcondor::params::singularity_bind_paths,
  $singularity_target_dir         = $htcondor::params::singularity_target_dir,
) inherits
::htcondor::params {
  if $install_repositories {
    class { 'htcondor::repositories': }
    Class['htcondor::repositories'] -> Class['htcondor::install']
  }

  class { 'htcondor::install':
  }

  class { 'htcondor::config':
  }

  class { 'htcondor::service':
  }

  Class['htcondor::install'] -> Class['htcondor::config'] -> Class['htcondor::service'
    ]
}
