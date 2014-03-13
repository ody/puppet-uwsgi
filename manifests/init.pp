class uwsgi(
    $service_ensure  = running,
    $package_ensure  = present,
    $plugin_packages = [ 'uwsgi-plugin-python' ],
) {

  package { 'uwsgi':
    ensure => $package_ensure,
    before => Package[$plugin_packages],
  }

  package { $plugin_packages:
    ensure => $package_ensured,
  }

  service { 'uwsgi':
    ensure     => $service_ensure,
    enable     => $service_ensure ? {
      'running' => true,
      'stopped' => false,
    },
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['uwsgi'],
      Package[$plugin_packages],
    ],
  }
}
