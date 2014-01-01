# == Class: roundcube
#
# Install and manage the Roundcube webmail application.
#
# === Parameters
#
# [*version*]
#   Set the version of the web application to be installed.
#
# [*md5*]
#   Set the MD5 hash sum of the web application's archive file.
#
# [*process*]
#   Set the process user that is used to execute the application; in this case the php interpreter.
#
# [*package_dir*]
#   Set the directory where to keep the downloaded software packages.
#
# [*install_dir*]
#   Set the directory where to install the web application.
#
# [*db_type*]
#   Set the type database (e.g. mysql or postgres).
#
# [*db_name*]
#   Set the name of the database.
#
# [*db_host*]
#   Set the hostname where the database is running. Puppet can only manage databases on the local host.
#
# [*db_user*]
#   Set the username used to connect to the database.
#
# [*db_password*]
#   Set the password used to authenticate the db_user.
#
# [*imap_host*]
#   Set the IMAP mail host chosen to perform the log-in (default_host configuration parameter).
#
# [*imap_port*]
#   Set the TCP port used for IMAP connections. Defaults to 143.
#
# [*des_key*]
#   Set key used to encrypt the users imap password which is stored.
#
# [*plugins*]
#   List of active plugins (in plugins/ directory).
#
# [*mime_param_folding*]
#   Set the encoding of long/non-ascii attachment names (see main.inc.php for possible values).
#
# [*language*]
#   Set the default locale setting (leave undef / empty for auto-detection).
#
# [*support_url*]
#   Set an URL where a user can get support for this Roundcube installation.
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
  $md5 = params_lookup('md5'),
  $process = params_lookup('process'),

  $package_dir = params_lookup('package_dir'),
  $install_dir = params_lookup('install_dir'),

  $db_type = params_lookup('db_type'),
  $db_name = params_lookup('db_name'),
  $db_host = params_lookup('db_host'),
  $db_user = params_lookup('db_user'),
  $db_password = params_lookup('db_password'),

  $imap_host = params_lookup('imap_host'),
  $imap_port = params_lookup('imap_port'),
  $des_key = params_lookup('des_key'),
  $plugins = params_lookup('plugins'),
  $mime_param_folding = params_lookup('mime_param_folding'),
  $language = params_lookup('language'),
  $support_url = params_lookup('support_url')
) inherits roundcube::params {
  validate_string($version)
  validate_string($md5)
  validate_string($process)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
  validate_string($db_type)
  validate_string($db_name)
  validate_string($db_host)
  validate_string($db_user)
  validate_string($db_password)
  validate_string($imap_host)
  validate_string($des_key)
  validate_array($plugins)
  validate_string($support_url)

  $application_dir = "${install_dir}/roundcubemail-${version}"

  class { 'roundcube::package':
    version     => $version,
    md5         => $md5,
    package_dir => $package_dir,
    install_dir => $install_dir,
  }

  class { 'roundcube::plugins':
    package_dir => $package_dir,
    install_dir => $application_dir,
    require     => Class['roundcube::package'],
  }

  class { 'roundcube::database':
    db_type     => $db_type,
    db_name     => $db_name,
    db_host     => $db_host,
    db_user     => $db_user,
    db_password => $db_password,
  }

  class { 'roundcube::config':
    application_dir => $application_dir,
    process         => $process,
    require         => Class['roundcube::package'],
  }
}
