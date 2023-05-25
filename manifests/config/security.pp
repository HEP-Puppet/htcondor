# This class is used to configure the security settings for HTCondor.
#
# Parameters:
#   $krb_srv_keytab: the path to the keytab file for the HTCondor service
#   $krb_srv_principal: the principal name for the HTCondor service
#   $krb_srv_user: the user name for the HTCondor service
#   $krb_srv_service: the service name for the HTCondor service
#   $krb_client_keytab: the path to the keytab file for the HTCondor client
#   $krb_mapfile_entries: an array of entries for the Kerberos mapfile
#
#   $condor_user: the user name for the HTCondor service
#   $condor_group: the group name for the HTCondor service
#   $pool_password_file: the path to the pool password file
#   $users_list: an array of users to be added to the HTCondor authorization
#     configuration
#
#   $schedulers: an array of machines that are schedulers
#   $managers: an array of machines that are managers
#   $workers: an array of machines that are workers
#
#   $queue_super_users: an array of users that are super users
#   $queue_super_user_impersonate: an array of users that are super users
#     that can impersonate other users
#   $use_anonymous_auth: a boolean indicating whether to use anonymous
#     authentication
#   $use_fs_auth: a boolean indicating whether to use file system
#     authentication
#   $use_password_auth: a boolean indicating whether to use password
#     authentication
#   $use_kerberos_auth: a boolean indicating whether to use Kerberos
#     authentication
#   $use_claim_to_be_auth: a boolean indicating whether to use claim-to-be
#     authentication
#   $use_ssl_auth: a boolean indicating whether to use SSL authentication
#
#   $use_cert_map_file: a boolean indicating whether to use a certificate map
#     file
#   $cert_map_file: the path to the certificate map file
#   $cert_map_file_source: the source of the certificate map file
#
#   $use_krb_map_file: a boolean indicating whether to use a Kerberos map file
#   $krb_map_file: the path to the Kerberos map file
#   $krb_map_file_template: the path to the Kerberos map file template
#
#   $ssl_server_keyfile: the path to the SSL server key file
#   $ssl_client_keyfile: the path to the SSL client key file
#   $ssl_server_certfile: the path to the SSL server certificate file
#   $ssl_client_certfile: the path to the SSL client certificate file
#   $ssl_server_cafile: the path to the SSL server CA file
#   $ssl_client_cafile: the path to the SSL client CA file
#   $ssl_server_cadir: the path to the SSL server CA directory
#   $ssl_client_cadir: the path to the SSL client CA directory

class htcondor::config::security (
  $krb_srv_keytab      = $htcondor::krb_srv_keytab,
  $krb_srv_principal   = $htcondor::krb_srv_principal,
  $krb_srv_user        = $htcondor::krb_srv_user,
  $krb_srv_service     = $htcondor::krb_srv_service,
  $krb_client_keytab   = $htcondor::krb_client_keytab,
  $krb_mapfile_entries = $htcondor::krb_mapfile_entries,
)
{
  # general - manifest or 1 or more configs
  $condor_user                  = $htcondor::condor_user
  $condor_group                 = $htcondor::condor_group
  $pool_password_file           = $htcondor::pool_password
  $users_list                   = $htcondor::users_list

  $schedulers                   = $htcondor::schedulers
  $managers                     = $htcondor::managers
  $workers                      = $htcondor::workers

  $queue_super_users            = $htcondor::queue_super_users
  $queue_super_user_impersonate = $htcondor::queue_super_user_impersonate
  $use_anonymous_auth           = $htcondor::use_anonymous_auth
  $use_fs_auth                  = $htcondor::use_fs_auth
  $use_password_auth            = $htcondor::use_password_auth
  $use_kerberos_auth            = $htcondor::use_kerberos_auth
  $use_claim_to_be_auth         = $htcondor::use_claim_to_be_auth
  $use_ssl_auth                 = $htcondor::use_ssl_auth

  $use_cert_map_file            = $htcondor::use_cert_map_file
  $cert_map_file                = $htcondor::cert_map_file
  $cert_map_file_source         = $htcondor::cert_map_file_source

  $use_krb_map_file             = $htcondor::use_krb_map_file
  $krb_map_file                 = $htcondor::krb_map_file
  $krb_map_file_template        = $htcondor::krb_map_file_template

  $ssl_server_keyfile           = $htcondor::ssl_server_keyfile
  $ssl_client_keyfile           = $htcondor::ssl_client_keyfile
  $ssl_server_certfile          = $htcondor::ssl_server_certfile
  $ssl_client_certfile          = $htcondor::ssl_client_certfile
  $ssl_server_cafile            = $htcondor::ssl_server_cafile
  $ssl_client_cafile            = $htcondor::ssl_client_cafile
  $ssl_server_cadir             = $htcondor::ssl_server_cadir
  $ssl_client_cadir             = $htcondor::ssl_client_cadir

  # /etc/condor/config.d/10_security.config
  $cluster_has_multiple_domains = $htcondor::cluster_has_multiple_domains
  $default_domain_name          = $htcondor::default_domain_name
  $filesystem_domain            = $htcondor::filesystem_domain
  $is_worker                    = $htcondor::is_worker
  $machine_prefix_remote        = $htcondor::machine_list_prefix
  $uid_domain                   = $htcondor::uid_domain

  # for private networks
  $uses_connection_broker       = $htcondor::uses_connection_broker
  $private_network_name         = $htcondor::private_network_name

  # template files
  $template_security            = $htcondor::template_security

  $auth_string                  = construct_auth_string($use_fs_auth,
  $use_password_auth, $use_kerberos_auth, $use_claim_to_be_auth,
  $use_anonymous_auth, $use_ssl_auth)

  # because HTCondor uses user 'condor_pool' for remote access
  # and user 'condor' for local the variables below need to include
  # both users in case a machine has more than one role (i.e. manager + CE)
  $machine_prefix_local         = "${condor_user}@$(UID_DOMAIN)/"

  $manager_list_local           = prefix($managers, $machine_prefix_local)
  $manager_list_remote          = prefix($managers, $machine_prefix_remote)
  $manager_list                 = union($manager_list_local,
  $manager_list_remote)

  $scheduler_list_local         = prefix($schedulers, $machine_prefix_local)
  $scheduler_list_remote        = prefix($schedulers, $machine_prefix_remote)
  $scheduler_list               = union($scheduler_list_local,
  $scheduler_list_remote)

  $worker_list_local            = prefix($workers, $machine_prefix_local)
  $worker_list_remote           = prefix($workers, $machine_prefix_remote)
  $worker_list                  = union($worker_list_local, $worker_list_remote)

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
      mode   => '0600',
    }
  }

  if $use_cert_map_file {
    file { $cert_map_file:
      ensure => present,
      source => $cert_map_file_source,
      owner  => $condor_user,
      group  => $condor_group,
    }
  }

  if $use_kerberos_auth {
    if $use_krb_map_file {
      file { $krb_map_file:
        ensure  => present,
        content => template($krb_map_file_template),
        owner   => $condor_user,
        group   => $condor_group,
      }
    }
  }
}
