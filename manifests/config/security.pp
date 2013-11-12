class htcondor::config::security (
  $computing_elements           = [],
  $cluster_has_multiple_domains = false,
  $managers                     = [],
  $uid_domain                   = 'example.com',
  $worker_nodes                 = [],) {
  # complex preparation of manager, computing_element and worker_nodes lists
  $managers_with_uid_domain = prefix($managers, '*@$(UID_DOMAIN)/')
  $computing_elements_with_uid_domain = prefix($computing_elements, '*@$(UID_DOMAIN)/'
  )
  $worker_nodes_with_uid_domain = prefix($worker_nodes, '*@$(UID_DOMAIN)/')

  file { '/etc/condor/config.d/10_security.config':
    content => template("${module_name}/10_security.config.erb"),
    require => Package['condor'],
  }
}
