# Class: htcondor
#
# @summary
# This module manages htcondor. Parameters that refer to condor 'knobs' (e.g.
# CONDOR_ADMIN) will not be explained here.
# Instead please refer to the HTCondor documentation:
# http://research.cs.wisc.edu/htcondor/manual/latest/3_3Configuration.html
#
# Defaults for the parameters can be found in htcondor::params
#
# @param schedulers [Array] List of schedulers that are allowed to submit jobs to the HTCondor pool.
# @param managers [Array] List of managers that the HTCondor pool should use.
# @param accounting_groups [Hash]
#   Accounting groups (and subgroups) for fair share configuration.
#   Requires use_accounting_groups = true. Default just provides an example for what needs to be specified.
# @param high_priority_groups [Hash]
#   A hash of groups with high priority. It is used for the group sorting expression for condor.
#   Groups with lower value are considered first.
# @param include_username_in_accounting [Boolean]
#   If false the accounting groups used are of the form group_<group_name>.<subgroup> and if true group_<group_name>.<subgroup>.<user name>.
# @param install_repositories [Boolean] Boolean to specify whether to install repositories or not.
# @param gpgcheck [Boolean] Boolean to specify whether the GPG signature of the packages should be checked.
# @param gpgkey [String] URL of the GPG key used to sign the packages.
# @param apt_key_id [String] ID of the GPG key used for apt repository.
# @param apt_key_source [String] URL to the GPG key used for apt repository.
# @param uid_domain [String] Condor UID_DOMAIN.
# @param use_accounting_groups [Boolean] If accounting groups should be used (fair shares).
# @param machine_owner [String] The owner of the machine (e.g. an accounting group).
# @param number_of_cpus [Integer] Number of CPUs available for condor scheduling.
# @param pool_password [String] Path to pool password file.
# @param users_list [Array] Customize the list of users in SCHEDD.ALLOW_WRITE.
# @param is_scheduler [Boolean] If the current machine is a condor scheduler.
# @param is_remote_submit [Boolean] If the current machine is a machine dedicated to submit jobs to a condor scheduler.
# @param is_manager [Boolean] If the machine is a manager or a negotiator (condor term).
# @param is_worker [Boolean] If the machine is a worker node.
# @param cluster_has_multiple_domains [Boolean] Specifies if the cluster has more than one domain.
# @param collector_name [String] Sets COLLECTOR_NAME in 22_manager.config.
# @param collector_query_workers [Integer] Sets COLLECTOR_QUERY_WORKERS in 22_manager.config.
# @param collector_max_file_descriptors [Integer] Sets COLLECTOR_MAX_FILE_DESCRIPTORS in 22_manager.config if defined.
# @param admin_email [String] Sets CONDOR_ADMIN.
# @param template_config_local [String] Path to the template for the config.local file.
# @param template_security [String] Path to the template for the security file.
# @param template_resourcelimits [String] Path to the template for the resourcelimits file.
# @param template_schedd [String] Path to the template for the schedd file.
# @param template_fairshares [String] Path to the template for the fairshares file.
# @param template_manager [String] Path to the template for the manager file.
# @param template_workernode [String] Path to the template for the workernode file.
# @param email_domain [String]
#   The email domain to use for the HTCondor pool. This is used to construct email addresses for job owners and administrators.
#   Defaults to 'example.com'.
# @param condor_priority [Integer] The priority of the HTCondor repository.
# @param condor_version [String] The version of HTCondor to install.
# @param custom_machine_attributes [Hash] A hash of custom machine attributes.
# @param custom_job_attributes [Hash] A hash of custom job attributes.
# @param claim_worklife [Integer] The number of seconds a claim will be kept alive after the job has finished.
# @param use_debug_notify [Boolean] If debug notifications should be enabled.
# @param enable_condor_reporting [Boolean] If condor reporting should be enabled.
# @param enable_cgroup [Boolean] If cgroup should be enabled.
# @param htcondor_cgroup [String] The cgroup to use for HTCondor.
# @param cgroup_memory_limit [String] The memory limit for the cgroup.
# @param enable_healthcheck [Boolean] If health check should be enabled.
# @param healthcheck_path [String] The path to put the health check script at.
# @param healthcheck_script [String] The path to the healthcheck script on the puppet master.
# @param healthcheck_period [Integer] The period in seconds between health checks.
# @param start_always_users [Array] List of users that should always be started.
# @param enable_multicore [Boolean] If multicore should be enabled.
# @param defrag_interval [Integer] The interval in seconds between defrag runs.
# @param defrag_draining_machines_per_hr [Integer] The number of machines that should be drained per hour.
# @param defrag_max_concurrent_draining [Integer] The maximum number of machines that should be drained concurrently.
# @param defrag_max_whole_machines [Integer] The maximum number of machines that should be drained.
# @param defrag_schedule [String] The schedule for defrag.
# @param defrag_rank [String] The rank expression for defrag.
# @param whole_machine_cpus [Integer] The number of CPUs that constitute a "whole" machine.
# @param defrag_requirements [String] The requirements expression for defrag.
# @param priority_halflife [Integer] The half life of the user priority.
# @param default_prio_factor [Integer] The default priority factor.
# @param group_accept_surplus [Boolean] If groups should accept surplus.
# @param group_autoregroup [Boolean] If groups should be autoregrouped.
# @param condor_major_version [String]
# The major version of HTCondor to install, e.g. 8.8. Will only be used if versioned_repos is true.
# @param versioned_repos [Boolean] If versioned repositories should be used.
# @param dev_repositories [Boolean] If development repositories should be used.
# @param partitionable_slots [Boolean] If partitionable slots should be used.
# @param memory_overcommit [Float] The memory overcommit factor.
# @param request_memory [String] The default memory request.
# @param starter_job_environment [Hash] A hash of environment variables to set for the starter.
# @param manage_selinux [Boolean] If SELinux should be managed.
# @param pool_home [String] The path to the pool directory.
# @param pool_create [Boolean] If the pool directory should be created.
# @param mount_under_scratch_dirs [Boolean] If the scratch directories should be mounted under work directory (separate per job).
# @param queues [String] Unused?
# @param periodic_expr_interval [Integer] The interval in seconds between periodic expressions.
# @param max_periodic_expr_interval [Integer] The maximum interval in seconds between periodic expressions.
# @param remove_held_jobs_after [Integer] The number of seconds after which held jobs should be removed.
# @param leave_job_in_queue [Boolean] The number of seconds the job is left in the queue after it has finished.
# @param ganglia_cluster_name [String] The name of the ganglia cluster.
# @param default_domain_name [String] The default domain name.
# @param filesystem_domain [String] Value for FILESYSTEM_DOMAIN. Defaults to FQDN.
# @param workers [Array] List of workers; used in security config.
# @param condor_user [String] The user that HTCondor should run as.
# @param condor_group [String] The group that HTCondor should run as.
# @param condor_uid [Integer] The UID that HTCondor should run as.
# @param condor_gid [Integer] The GID that HTCondor should run as.
# @param template_queues [String] Path to the template for the queues config.
# @param template_ganglia [String] Path to the template for the ganglia config.
# @param template_defrag [String] Path to the template for the defrag config.
# @param template_sharedport [String] Path to the template for the sharedport config.
# @param template_logging [String] Path to the template for the logging config.
# @param template_custom_knobs [String] Path to the template for the custom knobs config.
# @param template_singularity [String] Path to the template for the singularity config.
# @param template_highavailability [String] Path to the template for the high availability config.
# @param use_htcondor_account_mapping [Boolean] If HTCondor account mapping should be used.
# @param queue_super_users [Array] List of users that should be super users.
# @param queue_super_user_impersonate [Boolean] If super users should be able to impersonate other users.
# @param use_anonymous_auth [Boolean] If anonymous authentication should be used.
# @param use_fs_auth [Boolean] If filesystem authentication should be used.
# @param use_password_auth [Boolean] If password authentication should be used.
# @param use_kerberos_auth [Boolean] If kerberos authentication should be used.
# @param use_claim_to_be_auth [Boolean] If claim to be authentication should be used.
# @param use_cert_map_file [Boolean] If cert map file should be used.
# @param use_krb_map_file [Boolean] If kerberos map file should be used.
# @param use_ssl_auth [Boolean] If SSL authentication should be used.
# @param use_pid_namespaces [Boolean] If PID namespaces should be used (process isolation).
# @param uses_connection_broker [Boolean] If connection broker should be used.
# @param private_network_name [String] The name of the private network.
# @param schedd_blocked_users [Array] List of users that should be blocked from the scheduler daemon.
# @param schedd_blocked_user_msg [String] The message that should be displayed to blocked users.
# @param job_default_requestcpus [Integer] The default number of CPUs to request.
# @param job_default_requestmemory [String] The default amount of memory to request.
# @param job_default_requestdisk [String] The default amount of disk to request.
# @param cert_map_file [String] The path to the cert map file.
# @param cert_map_file_source [String] The source of the cert map file (on puppet master).
# @param krb_map_file [String] The path to the kerberos map file.
# @param krb_map_file_template [String] The template for the kerberos map file (on puppet master).
# @param krb_srv_keytab [String] The path to the kerberos service keytab.
# @param krb_srv_principal [String] The kerberos service principal.
# @param krb_srv_user [String] ???.
# @param krb_srv_service [String] ???.
# @param krb_client_keytab [String] The path to the kerberos client keytab.
# @param krb_mapfile_entries [Hash] A hash of entries for the map file.
# @param ssl_server_keyfile [String] The path to the SSL server key file.
# @param ssl_server_certfile [String] The path to the SSL server certificate file.
# @param ssl_server_cafile [String] The path to the SSL server CA file.
# @param ssl_server_cadir [String] The path to the SSL server CA directory.
# @param ssl_client_keyfile [String] The path to the SSL client key file.
# @param ssl_client_certfile [String] The path to the SSL client certificate file.
# @param ssl_client_cafile [String] The path to the SSL client CA file.
# @param ssl_client_cadir [String] The path to the SSL client CA directory.
# @param machine_list_prefix [String] The prefix for the machine list.
# @param max_walltime [Integer] The maximum walltime in seconds.
# @param max_cputime [Integer] The maximum cputime in seconds.
# @param memory_factor [Float] Translation factor for memory. Default: 1000
# @param dns_cache_refresh [Integer] The interval in seconds between DNS cache refreshes.
# @param use_shared_port [Boolean] If shared port should be used.
# @param shared_port [Integer] The shared port.
# @param shared_port_collector_name [String] The name of the shared port collector.
# @param max_history_log [Integer] The maximum size of the history log.
# @param max_history_rotations [Integer] The maximum number of history log rotations.
# @param rotate_history_daily [Boolean] If history log should be rotated daily.
# @param use_custom_logs [Boolean] If custom logs should be used.
# @param logging_parameters [Hash] A hash of logging parameters.
# @param log_to_syslog [Boolean] If logging to syslog should be used.
# @param custom_knobs [Hash] A hash of custom knobs (htcondor settings).
# @param use_singularity [Boolean] If singularity should be used.
# @param singularity_path [String] The path to singularity.
# @param force_singularity_jobs [Boolean] If singularity should be forced.
# @param singularity_image_expr [String] The singularity image expression.
# @param singularity_target_dir [String] The singularity target directory.
# @param singularity_bind_paths [Array] A list of paths to bind mount.
class htcondor (
  Hash $accounting_groups              = $htcondor::params::accounting_groups,
  Boolean $cluster_has_multiple_domains   =
    $htcondor::params::cluster_has_multiple_domains,
  String $collector_name                 = $htcondor::params::collector_name,
  Int $collector_query_workers        = $htcondor::params::collector_query_workers,
  Int $collector_max_file_descriptors = $htcondor::params::collector_max_file_descriptors,
  String $email_domain                   = $htcondor::params::email_domain,
  Variant[Array, String] $schedulers                     = $htcondor::params::schedulers,
  String $admin_email                    = $htcondor::params::admin_email,
  Int $condor_priority                = $htcondor::params::repo_priority,
  String $condor_version                 = $htcondor::params::condor_version,
  Hash $custom_machine_attributes      = $htcondor::params::custom_machine_attributes,
  Hash $custom_job_attributes          = $htcondor::params::custom_job_attributes,
  Int $claim_worklife                 = $htcondor::params::claim_worklife,
  Boolean $use_debug_notify               = $htcondor::params::use_debug_notify,
  Boolean $enable_condor_reporting        = $htcondor::params::enable_condor_reporting,
  Boolean $enable_cgroup                  = $htcondor::params::enable_cgroup,
  Boolean $enable_healthcheck             = $htcondor::params::enable_healthcheck,
  Array $start_always_users             = $htcondor::params::start_always_users,
  Boolean $enable_multicore               = $htcondor::params::enable_multicore,
  Int $defrag_interval                 = $htcondor::params::defrag_interval,
  Int $defrag_draining_machines_per_hr = $htcondor::params::defrag_draining_machines_per_hr,
  Int $defrag_max_concurrent_draining  = $htcondor::params::defrag_max_concurrent_draining,
  Int $defrag_max_whole_machines       = $htcondor::params::defrag_max_whole_machines,
  String $defrag_schedule                 = $htcondor::params::defrag_schedule,
  String $defrag_rank                     = $htcondor::params::defrag_rank,
  Int $whole_machine_cpus              = $htcondor::params::whole_machine_cpus,
  String $defrag_requirements             = $htcondor::params::defrag_requirements,
  String $htcondor_cgroup                = $htcondor::params::htcondor_cgroup,
  String $cgroup_memory_limit            = $htcondor::params::cgroup_memory_limit,
  Hash $high_priority_groups           = $htcondor::params::high_priority_groups,
  Int $priority_halflife              = $htcondor::params::priority_halflife,
  Float $default_prio_factor            = $htcondor::params::default_prio_factor,
  Boolean $group_accept_surplus           = $htcondor::params::group_accept_surplus,
  Boolean $group_autoregroup              = $htcondor::params::group_autoregroup,
  String $healthcheck_path               = $htcondor::params::healthcheck_path,
  String $healthcheck_script             = $htcondor::params::healthcheck_script,
  String $healthcheck_period             = $htcondor::params::healthcheck_period,
  Boolean $include_username_in_accounting =
    $htcondor::params::include_username_in_accounting,
  Boolean $install_repositories           = $htcondor::params::install_repositories,
  Boolean $gpgcheck                       = $htcondor::params::gpgcheck,
  String $gpgkey                         = $htcondor::params::gpgkey,
  String $apt_key_id                     = $htcondor::params::apt_key_id,
  String $apt_key_source                 = $htcondor::params::apt_key_source,
  String $condor_major_version           = $htcondor::params::condor_major_version,
  Boolean $versioned_repos                = $htcondor::params::versioned_repos,
  Boolean $dev_repositories               = $htcondor::params::dev_repositories,
  Boolean $is_scheduler                   = $htcondor::params::is_scheduler,
  Boolean $is_remote_submit               = $htcondor::params::is_remote_submit,
  Boolean $is_manager                     = $htcondor::params::is_manager,
  Boolean $is_worker                      = $htcondor::params::is_worker,
  String $machine_owner                  = $htcondor::params::machine_owner,
  Array $managers                       = $htcondor::params::managers,
  Int $number_of_cpus                 = $htcondor::params::number_of_cpus,
  Boolean $partitionable_slots            = $htcondor::params::partitionable_slots,
  Float $memory_overcommit              = $htcondor::params::memory_overcommit,
  Boolean $request_memory                 = $htcondor::params::request_memory,
  Hash $starter_job_environment        = $htcondor::params::starter_job_environment,
  Boolean $manage_selinux                 = $htcondor::params::manage_selinux,
  String $pool_home                      = $htcondor::params::pool_home,
  Boolean $pool_create                    = $htcondor::params::pool_create,
  Array $mount_under_scratch_dirs       = $htcondor::params::mount_under_scratch_dirs,
  String $queues                         = $htcondor::params::queues,
  Int $periodic_expr_interval         = $htcondor::params::periodic_expr_interval,
  Int $max_periodic_expr_interval     =
    $htcondor::params::max_periodic_expr_interval,
  Int $remove_held_jobs_after         = $htcondor::params::remove_held_jobs_after,
  Boolean $leave_job_in_queue             = $htcondor::params::leave_job_in_queue,
  String $ganglia_cluster_name           = $htcondor::params::ganglia_cluster_name,
  String $pool_password                  = $htcondor::params::pool_password_file,
  String $users_list                     = $htcondor::params::users_list,
  String $uid_domain                     = $htcondor::params::uid_domain,
  String $default_domain_name            = $htcondor::params::default_domain_name,
  String $filesystem_domain              = $htcondor::params::filesystem_domain,
  Boolean $use_accounting_groups          = $htcondor::params::use_accounting_groups,
  Array $workers                        = $htcondor::params::workers,
  # default params
  String $condor_user                    = root,
  String $condor_group                   = root,
  Int $condor_uid                     = 0,
  Int $condor_gid                     = 0,
  # template selection. Allow for user to override
  String $template_config_local          = $htcondor::params::template_config_local,
  String $template_security              = $htcondor::params::template_security,
  String $template_resourcelimits        = $htcondor::params::template_resourcelimits,
  String $template_queues                = $htcondor::params::template_queues,
  String $template_schedd                = $htcondor::params::template_schedd,
  String $template_fairshares            = $htcondor::params::template_fairshares,
  String $template_manager               = $htcondor::params::template_manager,
  String $template_ganglia               = $htcondor::params::template_ganglia,
  String $template_workernode            = $htcondor::params::template_workernode,
  String $template_defrag                = $htcondor::params::template_defrag,
  String $template_sharedport            = $htcondor::params::template_sharedport,
  String $template_logging               = $htcondor::params::template_logging,
  String $template_custom_knobs          = $htcondor::params::template_custom_knobs,
  String $template_singularity           = $htcondor::params::template_singularity,
  String $template_highavailability      =
    $htcondor::params::template_highavailability,
  Boolean $use_htcondor_account_mapping   =
    $htcondor::params::use_htcondor_account_mapping,
  Array $queue_super_users              = $htcondor::params::queue_super_users,
  String $queue_super_user_impersonate   = $htcondor::params::queue_super_user_impersonate,
  Boolean $use_anonymous_auth             = $htcondor::params::use_anonymous_auth,
  Boolean $use_fs_auth                    = $htcondor::params::use_fs_auth,
  Boolean $use_password_auth              = $htcondor::params::use_password_auth,
  Boolean $use_kerberos_auth              = $htcondor::params::use_kerberos_auth,
  Boolean $use_claim_to_be_auth           = $htcondor::params::use_claim_to_be_auth,
  Boolean $use_cert_map_file              = $htcondor::params::use_cert_map_file,
  Boolean $use_krb_map_file               = $htcondor::params::use_krb_map_file,
  Boolean $use_ssl_auth                   = $htcondor::params::use_ssl_auth,
  Boolean $use_pid_namespaces             = $htcondor::params::use_pid_namespaces,
  Boolean $uses_connection_broker         = $htcondor::params::uses_connection_broker,
  String $private_network_name           = $htcondor::params::private_network_name,
  Array $schedd_blocked_users           = $htcondor::params::schedd_blocked_users,
  String $schedd_blocked_user_msg        = $htcondor::params::schedd_blocked_user_msg,
  String $job_default_requestcpus        = $htcondor::params::job_default_requestcpus,
  String $job_default_requestdisk        = $htcondor::params::job_default_requestdisk,
  String $job_default_requestmemory      = $htcondor::params::job_default_requestmemory,
  String $cert_map_file                  = $htcondor::params::cert_map_file,
  String $cert_map_file_source           = $htcondor::params::cert_map_file_source,
  String $krb_map_file                   = $htcondor::params::krb_map_file,
  String $krb_map_file_template          = $htcondor::params::krb_map_file_template,
  String $krb_srv_keytab                 = undef,
  String $krb_srv_principal              = undef,
  String $krb_srv_user                   = undef,
  String $krb_srv_service                = undef,
  String $krb_client_keytab              = undef,
  Hash $krb_mapfile_entries            = {},
  String $ssl_server_keyfile             = $htcondor::params::ssl_server_keyfile,
  String $ssl_client_keyfile             = $htcondor::params::ssl_client_keyfile,
  String $ssl_server_certfile            = $htcondor::params::ssl_server_certfile,
  String $ssl_client_certfile            = $htcondor::params::ssl_client_certfile,
  String $ssl_server_cafile              = $htcondor::params::ssl_server_cafile,
  String $ssl_client_cafile              = $htcondor::params::ssl_client_cafile,
  String $ssl_server_cadir               = $htcondor::params::ssl_server_cadir,
  String $ssl_client_cadir               = $htcondor::params::ssl_client_cadir,
  String $machine_list_prefix            = $htcondor::params::machine_list_prefix,
  String $max_walltime                   = $htcondor::params::max_walltime,
  String $max_cputime                    = $htcondor::params::max_cputime,
  String $memory_factor                  = $htcondor::params::memory_factor,
  Int $dns_cache_refresh              = $htcondor::params::dns_cache_refresh,
  Boolean $use_shared_port                = $htcondor::params::use_shared_port,
  Int $shared_port                    = $htcondor::params::shared_port,
  String $shared_port_collector_name     = $htcondor::params::shared_port_collector_name,
  Int $max_history_log                = $htcondor::params::max_history_log,
  Int $max_history_rotations          = $htcondor::params::max_history_rotations,
  Boolean $rotate_history_daily           = $htcondor::params::rotate_history_daily,
  Boolean $use_custom_logs                = $htcondor::params::use_custom_logs,
  Boolean $log_to_syslog                  = $htcondor::params::log_to_syslog,
  Hash $logging_parameters             = $htcondor::params::logging_parameters,
  Hash $custom_knobs                   = $htcondor::params::custom_knobs,
  Boolean $use_singularity                = $htcondor::params::use_singularity,
  String $singularity_path               = $htcondor::params::singularity_path,
  Boolean $force_singularity_jobs         = $htcondor::params::force_singularity_jobs,
  String $singularity_image_expr         = $htcondor::params::singularity_image_expr,
  String $singularity_bind_paths         = $htcondor::params::singularity_bind_paths,
  String $singularity_target_dir         = $htcondor::params::singularity_target_dir,
) inherits htcondor::params {
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
