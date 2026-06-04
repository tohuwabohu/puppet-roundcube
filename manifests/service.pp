# Class: roundcube::service
#
# Service management related configuration.
#
# It is a PHP-based web application. Normally, no service needs to be notified. Every change should happen instantly.
# Hence, the final step of the installation is to update the symbolic link referencing the current version.
#
# === Copyright
#
# Copyright 2015 Martin Meinhold, unless otherwise noted.
#
class roundcube::service inherits roundcube {

  if $roundcube::document_root_manage {
    if versioncmp($roundcube::version, '1.7.0') < 0 {
      $real_target = $roundcube::install::target
    } else {
      $real_target = "${$roundcube::install::target}/public_html"
    }

    file { $roundcube::document_root:
      ensure => link,
      target => $real_target,
      owner  => 'root',
      group  => 0,
    }
  }
}
