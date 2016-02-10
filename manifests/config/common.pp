# Common parts of condor configuration
class htcondor::config::common {
  # general - manifest or 1 or more configs
  $condor_user                    = $htcondor::condor_user
  $condor_group                   = $htcondor::condor_group
  # /etc/condor/condor_config.local
  $admin_email                    = $htcondor::admin_email
  $email_domain                   = $htcondor::email_domain
  $condor_uid                     = $htcondor::condor_uid
  $condor_gid                     = $htcondor::condor_gid

  $is_scheduler                   = $htcondor::is_scheduler
  $use_htcondor_account_mapping   = $htcondor::use_htcondor_account_mapping
  $include_username_in_accounting = $htcondor::include_username_in_accounting

  $leave_job_in_queue             = $htcondor::leave_job_in_queue
  $request_memory                 = $htcondor::request_memory
  $use_pkg_condor_config          = $htcondor::use_pkg_condor_config

  $template_config_local          = $htcondor::template_config_local

  $now                            = strftime('%d.%m.%Y_%H.%M')

  # files common between machines
  unless $use_pkg_condor_config {
    file { '/etc/condor/condor_config':
      backup  => ".bak.${now}",
      source  => "puppet:///modules/${module_name}/condor_config",
      require => Package['condor'],
      owner   => $condor_user,
      group   => $condor_group,
      mode    => '0644',
      notify  => Exec['/usr/sbin/condor_reconfig'],
    }
  }

  file { '/etc/condor/condor_config.local':
    backup  => ".bak.${now}",
    content => template($template_config_local),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }
}
