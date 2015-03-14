# Class: roundcube::install
#
# Install the Roundcube software package.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube::install inherits roundcube {

  $archive = "roundcubemail-${roundcube::version}"
  $target = "${roundcube::install_dir}/${archive}"
  $download_url = "http://netcologne.dl.sourceforge.net/project/roundcubemail/roundcubemail/${roundcube::version}/${archive}.tar.gz"

  archive { $archive:
    ensure         => present,
    digest_string  => $roundcube::md5,
    url            => $download_url,
    follow_remotes => true,
    target         => $roundcube::install_dir,
    src_target     => $roundcube::package_dir,
    timeout        => 600,
    require        => [
      File[$roundcube::install_dir],
      File[$roundcube::package_dir]
    ],
  }

  file { ["${target}/logs", "${target}/temp"]:
    ensure  => directory,
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0644',
    require => Archive[$archive],
  }
}
