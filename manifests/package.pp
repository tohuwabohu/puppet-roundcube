# Class: roundcube::package
#
# The Roundcube software package.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube::package($version, $md5, $package_dir, $install_dir, $process) {
  validate_string($version)
  validate_string($md5)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
  validate_string($process)

  $archive = "roundcubemail-${version}"
  $target = "${install_dir}/${archive}"
  $download_url = "http://netcologne.dl.sourceforge.net/project/roundcubemail/roundcubemail/${version}/${archive}.tar.gz"

  archive { $archive:
    ensure        => present,
    digest_string => $md5,
    url           => $download_url,
    target        => $install_dir,
    src_target    => $package_dir,
    timeout       => 600,
    require       => [File[$install_dir], File[$package_dir]],
  }

  file { "${install_dir}/roundcubemail-current":
    ensure  => link,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    require => Archive[$archive],
  }

  file { ["${target}/logs", "${target}/temp"]:
    ensure  => directory,
    owner   => $process,
    group   => $process,
    mode    => '0644',
    require => Archive[$archive],
  }
}
