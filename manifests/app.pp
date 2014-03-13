define uwsgi::app(
  $ensure         = present,
  $enable         = true,
  $chdir          = "/var/www/${name}",
  $wsgi_file      = "/var/www/${name}/wsgi.py",
  $socket         = "/tmp/${name}.uwsgi",
  $threads        = "${::processorcount * 2}",
  $vacuum         = true,
  $master         = true,
  $enable_threads = true,
  $plugins,
  $pythonpath,
  $user,
  $group,
) {

  $ini_parameters = {
     'chdir'          => $chdir,
     'wsgi-file'      => $wsgi_file,
     'socket'         => $socket,
     'threads'        => $threads,
     'vacuum'         => $vacuum,
     'master'         => $master,
     'enable-threads' => $enable_threads,
     'plugins'        => $plugins,
     'pythonpath'     => $pythonpath,
     'uid'            => $user,
     'gid'            => $group,
  }

  case $ensure {
    present: {
      $ini_parameters.each |$index, $value| {
        ini_setting { "${name}_${index}":
          ensure  => present,
          path    => "/etc/uwsgi/apps-available/${name}.ini",
          section => 'uwsgi',
          setting => $index,
          value   => $value,
        }
      }
      if $enable {
        file { "/etc/uwsgi/apps-enabled/${name}.ini":
          ensure => symlink,
          target => "/etc/uwsgi/apps-available/${name}.ini",
        }
      } else {
        file { "/etc/uwsgi/apps-enabled/${name}.ini": ensure => absent }
      }
    }
    absent: {
      file { "/etc/uwsgi/apps-enabled/${name}.ini":   ensure => absent }
      file { "/etc/uwsgi/apps-available/${name}.ini": ensure => absent }
    }
    default: {
      fail("The only valid ensure values for Uwsgi::App[${name}] are present and absent")
    }
  }
}
