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
    ensure        => present,
    digest_string => $roundcube::md5,
    url           => $download_url,
    target        => $roundcube::install_dir,
    src_target    => $roundcube::package_dir,
    timeout       => 600,
    require       => [
      File[$roundcube::install_dir],
      File[$roundcube::package_dir]
    ],
  }

  # plugin version 1.6, 22nd October 2013
  archive { 'markasjunk2':
    ensure        => present,
    digest_string => '96d6ded230ca1aaf9900036e67446bd3',
    url           => 'http://www.tehinterweb.co.uk/roundcube/plugins/markasjunk2.tar.gz',
    target        => "${target}/plugins",
    src_target    => $roundcube::package_dir,
    timeout       => 600,
    require       => [
      Archive[$archive],
      File[$roundcube::package_dir],
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
