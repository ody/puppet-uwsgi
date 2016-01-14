class uwsgi(
    $uid             = 'uwsgi',
    $gid             = 'uwsgi',
    $pidfile         = '/run/uwsgi/uwsgi.pid',
    $emperor         = '/etc/uwsgi.d',
    $stats           = '/run/uwsgi/stats.sock',
    $tyrant          = true,
    $cap             = [ 'setgid', 'setuid'],
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

  uwsgi_config {
    'uwsgi/uid':            value => $uid;
    'uwsgi/gid':            value => $gid;
    'uwsgi/pidfile':        value => $pidfile;
    'uwsgi/emperor':        value => $emperor;
    'uwsgi/stats':          value => $stats;
    'uwsgi/emperor-tyrant': value => $tyrant;
    'uwsgi/cap':            value => join($cap, ',');
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

  Uwsgi_config <||> ~> Service['uwsgi']
}
