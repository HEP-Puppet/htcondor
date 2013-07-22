class htcondor::repositories (
  $install_repos = true,) {
  if $install_repos {
    $major_release = regsubst($::operatingsystemrelease, '^(\d+)\.\d+$', '\1')

    case $::osfamily {
      'RedHat'  : {
        yumrepo { 'htcondor-stable':
          descr    => "HTCondor Stable RPM Repository for Redhat Enterprise Linux ${major_release}",
          baseurl  => "http://research.cs.wisc.edu/htcondor/yum/stable/rhel${major_release}",
          enabled  => true,
          gpgcheck => false,
        }
      }
      'Debian'  : {
        # http://research.cs.wisc.edu/htcondor/debian/
        notify { 'Debian based systems currently not supported': }
      }
      'Windows' : {
        # http://research.cs.wisc.edu/htcondor/manual/v8.0/3_2Installation.html#SECTION00425000000000000000
        notify { 'Windows based systems currently not supported': }
      }
      default   : {
        $osfamily = $::osfamily

        notify { "OS family '${osfamily}' not recognised": }
      }
    }

  }
}