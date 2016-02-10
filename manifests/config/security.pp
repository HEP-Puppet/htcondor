class htcondor::config::security {
  # general - manifest or 1 or more configs
  $condor_user           = $htcondor::condor_user
  $condor_group          = $htcondor::condor_group
  $pool_password_file    = $htcondor::pool_password

  $schedulers            = $htcondor::schedulers
  $managers              = $htcondor::managers
  $workers               = $htcondor::workers

  $use_fs_auth           = $htcondor::use_fs_auth
  $use_password_auth     = $htcondor::use_password_auth
  $use_kerberos_auth     = $htcondor::use_kerberos_auth
  $use_claim_to_be_auth  = $htcondor::use_claim_to_be_auth

  $use_cert_map_file     = $htcondor::use_cert_map_file
  $cert_map_file         = $htcondor::cert_map_file
  $cert_map_file_source  = $htcondor::certificate_mapfile

  $use_krb_map_file      = $htcondor::use_krb_map_file
  $krb_map_file          = $htcondor::krb_map_file
  $krb_map_file_source   = $htcondor::kerberos_mapfile

  # /etc/condor/config.d/10_security.config
  $default_domain_name   = $htcondor::default_domain_name
  $filesystem_domain     = $htcondor::filesystem_domain
  $is_worker             = $htcondor::is_worker
  $machine_list_prefix   = $htcondor::machine_list_prefix
  $uid_domain            = $htcondor::uid_domain

  # template files
  $template_security     = $htcondor::template_security

  $auth_string           = construct_auth_string($use_fs_auth,
  $use_password_auth, $use_kerberos_auth, $use_claim_to_be_auth)

  # because HTCondor uses user 'condor_pool' for remote access
  # and user 'condor' for local the variables below need to include
  # both users in case a machine has more than one role (i.e. manager + CE)
  $machine_prefix_local  = "${condor_user}@$(UID_DOMAIN)/"

  $manager_string_remote = join_machine_list($machine_list_prefix, $managers)
  $manager_string_local  = join_machine_list($machine_prefix_local, $managers)
  $manager_string        = join([$manager_string_remote, $manager_string_local], ', '
  )

  $sched_string_remote   = join_machine_list($machine_list_prefix, $schedulers)
  $sched_string_local    = join_machine_list($machine_prefix_local, $schedulers)
  $sched_string          = join([$sched_string_remote, $sched_string_local], ', '
  )

  $wn_string_remote      = join_machine_list($machine_list_prefix, $workers)
  $wn_string_local       = join_machine_list($machine_prefix_local, $workers)
  $wn_string             = join([$wn_string_remote, $wn_string_local], ', ')

  file { '/etc/condor/config.d/10_security.config':
    content => template($template_security),
    require => Package['condor'],
    owner   => $condor_user,
    group   => $condor_group,
    mode    => '0644',
    notify  => Exec['/usr/sbin/condor_reconfig'],
  }

  if $use_password_auth {
    # even if condor runs as condor, it just drops privileges and needs to start
    # as root.
    # if file is not owned by root, condor will throw this error :
    # 06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real
    # uid
    # 06/12/14 15:38:40 error: SEC_PASSWORD_FILE must be owned by Condor's real
    # uid
    file { '/etc/condor/pool_password':
      ensure => present,
      source => $pool_password_file,
      owner  => root,
      group  => root,
      mode   => '0640',
    }
  }

  if $use_kerberos_auth {
    if $use_cert_map_file {
      file { $cert_map_file:
        ensure => present,
        source => $cert_map_file_source,
        owner  => $condor_user,
        group  => $condor_group,
      }
    }

    if $use_krb_map_file {
      file { $krb_map_file:
        ensure => present,
        source => $krb_map_file_source,
        owner  => $condor_user,
        group  => $condor_group,
      }
    }
  }
}
