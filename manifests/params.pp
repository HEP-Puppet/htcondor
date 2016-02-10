# htcondor::params
class htcondor::params {
  $schedulers = hiera_array('schedulers', [])

  $is_scheduler = hiera('is_scheduler', false)
  $default_accounting_groups = {
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
  $accounting_groups         = hiera_hash('accounting_groups',
  $default_accounting_groups)

  # notification settings
  $admin_email               = hiera('admin_email', 'localhost')
  $email_domain = hiera('email_domain', 'localhost')
  # template paths
  $template_config_local     = hiera('template_config_local', "${module_name}/condor_config.local.erb"
  )
  $template_security         = hiera('template_security', "${module_name}/10_security.config.erb"
  )
  $template_resourcelimits   = hiera('template_resourcelimits', "${module_name}/12_resourcelimits.config.erb"
  )
  $template_queues           = hiera('template_queues', "${module_name}/13_queues.config.erb"
  )
  $template_schedd           = hiera('template_schedd', "${module_name}/21_schedd.config.erb"
  )
  $template_fairshares       = hiera('template_fairshares', "${module_name}/11_fairshares.config.erb"
  )
  $template_manager        = hiera('template_collector', "${module_name}/22_manager.config.erb"
  )
  $template_ganglia          = hiera('template_ganglia', "${module_name}/23_ganglia.config.erb"
  )
  $template_workernode       = hiera('template_workernode', "${module_name}/20_workernode.config.erb"
  )
  $template_defrag           = hiera('template_defrag', "${module_name}/33_defrag.config.erb"
  )
  $template_highavailability = hiera('template_defrag', "${module_name}/30_highavailability.config.erb"
  )
}
