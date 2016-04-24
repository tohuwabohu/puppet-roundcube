# Class: roundcube::install
#
# Install the Roundcube software package.
#
# === Copyright
#
# Copyright 2015 Martin Meinhold, unless otherwise noted.
#
class roundcube::install inherits roundcube {

  include composer

  $archive = "roundcubemail-${roundcube::version}-complete"
  $target = "${roundcube::install_dir}/roundcubemail-${roundcube::version}"
  $download_url = "https://github.com/roundcube/roundcubemail/releases/download/${roundcube::version}/${archive}.tar.gz"
  $composer_install_cmd = "${roundcube::composer_command_name} install --no-dev"

  archive { $archive:
    ensure           => present,
    digest_string    => $roundcube::checksum,
    digest_type      => $roundcube::checksum_type,
    url              => $download_url,
    follow_redirects => true,
    target           => $roundcube::install_dir,
    src_target       => $roundcube::package_dir,
    root_dir         => "roundcubemail-${roundcube::version}",
    timeout          => 600,
    require          => [
      File[$roundcube::install_dir],
      File[$roundcube::package_dir]
    ],
  }

  file { ["${target}/logs", "${target}/temp"]:
    ensure  => directory,
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0640',
    require => Archive[$archive],
  }

  file { "${target}/installer":
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
    backup  => false,
    require => Archive[$archive],
  }

  file { "${target}/composer.json":
    ensure  => file,
    source  => "${target}/composer.json-dist",
    replace => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Archive[$archive],
  }

  ->

  augeas { "${target}/composer.json__prefer-stable":
    lens    => 'Json.lns',
    incl    => "${target}/composer.json",
    changes => [
      "set dict/entry[. = 'prefer-stable'] prefer-stable",
      "set dict/entry[. = 'prefer-stable']/const true",
    ],
  }

  ->

  exec { $composer_install_cmd:
    unless      => "${composer_install_cmd} --dry-run 2>&1 | grep -q -F 'Nothing to install or update'",
    cwd         => $target,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
  }
}
