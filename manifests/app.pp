define uwsgi::app(
  $ensure         = present,
  $chdir          = "/var/www/${name}",
  $socket         = "/run/uwsgi/${name}.sock",
  $processes      = $::processorcount,
  $threads        = $::processorcount * 2,
  $vacuum         = true,
  $master         = true,
  $enable_threads = true,
  $chmod_socket   = '660',
  $uid            = 'uwsgi',
  $gid            = 'uwsgi',
  $plugins        = 'python',
  $wsgi_file,
) {

  case $ensure {
    present: {
      uwsgi_app_config {
        default:                path => "/etc/uwsgi.d/${name}.ini";
        'uwsgi/chdir':          value => $chdir;
        'uwsgi/socket':         value => $socket;
        'uwsgi/threads':        value => $threads;
        'uwsgi/processes':      value => $processes;
        'uwsgi/vacuum':         value => $vacuum;
        'uwsgi/master':         value => $master;
        'uwsgi/enable-threads': value => $enable;
        'uwsgi/module':         value => $module;
        'uwsgi/chmod-socket':   value => $chmod_socket;
        'uwsgi/chown-socket':   value => $chown_socket;
        'uwsgi/wsgi-file':      value => $wsgi_file;
        'uwsgi/plugins':        value => $plugins;
      }
      file { ["/etc/uwsgi.d/${name}.ini"]:
        mode => '0600',
        owner => $::uwsgi::uid,
        group => $::uwsgi::gid,
      }
    }
    absent: {
      file { "/etc/uwsgi.d/${name}.ini":   ensure => absent }
    }
    default: {
      fail("The only valid ensure values for Uwsgi::App[${name}] are present and absent")
    }
  }
}
