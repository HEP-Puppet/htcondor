# Class: htcondor::repositories
#
# Provides yum repositories for HTCondor installation
class htcondor::repositories {
  $htcondor_major  = $htcondor::condor_major_version
  $versioned_repos = $htcondor::versioned_repos
  $dev_repos       = $htcondor::dev_repositories
  $gpgcheck        = $htcondor::gpgcheck
  $gpgkey          = $htcondor::gpgkey
  $apt_key_id      = $htcondor::apt_key_id
  $apt_key_source  = $htcondor::apt_key_source
  $condor_priority = $htcondor::condor_priority
  $major_release   = $facts['os']['release']['major']

  case $facts['os']['family'] {
    'RedHat'  : {
      if $dev_repos {
        yumrepo { 'htcondor-development':
          descr    => "HTCondor Development RPM Repository for Redhat Enterprise Linux ${facts['os']['release']['major']}",
          baseurl  => 'https://research.cs.wisc.edu/htcondor/yum/development/rhel$releasever',
          enabled  => 1,
          gpgcheck => bool2num($gpgcheck),
          gpgkey   => $gpgkey,
          priority => $condor_priority,
          exclude  => 'condor.i386, condor.i686',
          before   => [Package['condor']],
        }
      } else {
        if $versioned_repos {
          $repo_url = "https://research.cs.wisc.edu/htcondor/repo/${htcondor_major}/el\$releasever/release"
        } else {
          $repo_url = 'https://research.cs.wisc.edu/htcondor/yum/stable/rhel$releasever'
        }
        yumrepo { 'htcondor-stable':
          descr    => "HTCondor Stable RPM Repository for Redhat Enterprise Linux ${facts['os']['release']['major']}",
          baseurl  => $repo_url,
          enabled  => 1,
          gpgcheck => bool2num($gpgcheck),
          gpgkey   => $gpgkey,
          priority => $condor_priority,
          exclude  => 'condor.i386, condor.i686',
          before   => [Package['condor']],
        }
      }
    }
    'Debian'  : {
      $distro_name = downcase($facts['os']['name'])
      $distro_code = $facts['os']['distro']['codename']
      apt::source { 'htcondor':
        ensure         => present,
        allow_unsigned => false,
        comment        => "HTCondor ${distro_name} Repository",
        location       => "https://research.cs.wisc.edu/htcondor/repo/${distro_name}/${htcondor_major}",
        repos          => 'main',
        release        => $distro_code,
        architecture   => 'amd64',
        key            => {
          ensure => refreshed,
          id     => $apt_key_id,
          source => $apt_key_source,
        },
        include        => {
          src => false,
          deb => true,
        },
        notify_update  => true,
      }
    }
    'Windows' : {
      # http://research.cs.wisc.edu/htcondor/manual/latest/3_2Installation.html#SECTION00425000000000000000
      notify { 'Windows based systems currently not supported': }
    }
    default   : {
      $osfamily = $facts['os']['family']

      notify { "OS family '${osfamily}' not recognised": }
    }
  }
}
