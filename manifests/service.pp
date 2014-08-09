# Class: roundcube::service
#
# Service management related configuration.
#
# It is a PHP-based web application. Normally, no service needs to be notified. Every change should happen instantly.
# Hence, the final step of the installation is to update the symbolic link referencing the current version.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube::service inherits roundcube {

  file { $roundcube::document_root:
    ensure  => link,
    target  => $roundcube::install::target,
    owner   => 'root',
    group   => 'root',
  }
}
