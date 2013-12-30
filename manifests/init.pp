# == Class: roundcube
#
# Install and manage the Roundcube webmail application.
#
# === Parameters
#
# [*version*]
#   The version of the web application to be installed.
#
# [*md5*]
#   The MD5 hash sum of the web application archive.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube (
  $version = params_lookup('version'),
  $md5 = params_lookup('md5')
) inherits roundcube::params {
  validate_string($version)
  validate_string($md5)

  class { 'roundcube::package':
    version => $version,
    md5     => $md5,
  }
}
