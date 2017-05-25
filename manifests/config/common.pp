# Common parts of condor configuration
class htcondor::config::common {
  # general - manifest or 1 or more configs
  $condor_user                    = $htcondor::condor_user
  $condor_group                   = $htcondor::condor_group
  # /etc/condor/condor_config.local
  $admin_email                    = $htcondor::admin_email
  $enable_condor_reporting        = $htcondor::enable_condor_reporting
  $email_domain                   = $htcondor::email_domain
  $condor_uid                     = $htcondor::condor_uid
  $condor_gid                     = $htcondor::condor_gid

  $is_scheduler                   = $htcondor::is_scheduler
  $use_htcondor_account_mapping   = $htcondor::use_htcondor_account_mapping
  $include_username_in_accounting = $htcondor::include_username_in_accounting

  $leave_job_in_queue             = $htcondor::leave_job_in_queue
  $request_memory                 = $htcondor::request_memory

  $template_config_local          = $htcondor::template_config_local

  $now                            = strftime('%d.%m.%Y_%H.%M')

  # files common between machines
  file { '/etc/condor/config.d/00_config_local.config':
    backup  => ".bak.${now}",
    content => template($template_config_local),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }
}
