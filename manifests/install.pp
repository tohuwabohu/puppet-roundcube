# Class: roundcube::install
#
# Install the Roundcube software package.
#
# === Copyright
#
# Copyright 2015 Martin Meinhold, unless otherwise noted.
#
class roundcube::install inherits roundcube {

  $archive_name = "roundcubemail-${roundcube::version}-complete.tar.gz"
  $target = "${roundcube::install_dir}/roundcubemail-${roundcube::version}"
  $download_url = "https://github.com/roundcube/roundcubemail/releases/download/${roundcube::version}/${archive_name}"
  $composer_install_cmd = "${roundcube::composer_command_name} install --no-dev"

  archive { $archive_name:
    ensure        => present,
    path          => "${roundcube::package_dir}/${archive_name}",
    source        => $download_url,
    proxy_server  => $roundcube::archive_proxy_server,
    extract       => true,
    extract_path  => $roundcube::install_dir,
    extract_flags => '-x --no-same-owner -f',
    creates       => "${roundcube::install_dir}/roundcubemail-${roundcube::version}",
    checksum      => $roundcube::checksum,
    checksum_type => $roundcube::checksum_type,
    cleanup       => false,
    require       => [
      File[$roundcube::install_dir],
      File[$roundcube::package_dir]
    ],
  }

  file { ["${target}/logs", "${target}/temp"]:
    ensure  => directory,
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0640',
    require => Archive[$archive_name],
  }

  file { "${target}/installer":
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
    backup  => false,
    require => Archive[$archive_name],
  }

  file { "${target}/composer.json":
    ensure  => file,
    source  => "${target}/composer.json-dist",
    replace => false,
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    require => Archive[$archive_name],
  }

  -> augeas { "${target}/composer.json__prefer-stable":
    lens    => 'Json.lns',
    incl    => "${target}/composer.json",
    changes => [
      "set dict/entry[. = 'prefer-stable'] prefer-stable",
      "set dict/entry[. = 'prefer-stable']/const true",
    ],
  }

  -> exec { $composer_install_cmd:
    unless      => "${composer_install_cmd} --dry-run 2>&1 | grep -q -F 'Nothing to install'",
    cwd         => $target,
    user        => $roundcube::composer_user,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
  }
}
