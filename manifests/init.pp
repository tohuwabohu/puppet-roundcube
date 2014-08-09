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
# [*db_username*]
#   Set the username used to connect to the database.
#
# [*db_password*]
#   Set the password used to authenticate the database user.
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
# [*password_minimum_length*]
#   Set minimum lenght a new password must have.
#
# [*password_require_nonalpha*]
#   Set to true to require the new password to contain a letter and punctuation character
#
# [*password_db_dsn*]
#   Set PEAR database DSN for performing the query. By default the Roundcube DB settings are used.
#
# [*password_query*]
#   Set the SQL query used to change the password.
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
  $version                   = $roundcube::params::version,
  $md5                       = $roundcube::params::md5,
  $process                   = $roundcube::params::process,

  $package_dir               = $roundcube::params::package_dir,
  $install_dir               = $roundcube::params::install_dir,

  $db_type                   = $roundcube::params::db_type,
  $db_name                   = $roundcube::params::db_name,
  $db_host                   = $roundcube::params::db_host,
  $db_username               = $roundcube::params::db_username,
  $db_password               = $roundcube::params::db_password,

  $imap_host                 = $roundcube::params::imap_host,
  $imap_port                 = $roundcube::params::imap_port,
  $des_key                   = $roundcube::params::des_key,
  $plugins                   = $roundcube::params::plugins,
  $mime_param_folding        = $roundcube::params::mime_param_folding,
  $language                  = $roundcube::params::language,
  $support_url               = $roundcube::params::support_url,

  $password_minimum_length   = $roundcube::params::password_minimum_length,
  $password_require_nonalpha = $roundcube::params::password_require_nonalpha,
  $password_db_dsn           = $roundcube::params::password_db_dsn,
  $password_query            = $roundcube::params::password_query
) inherits roundcube::params {
  validate_string($version)
  validate_string($md5)
  validate_string($process)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
  validate_string($db_type)
  validate_string($db_name)
  validate_string($db_host)
  validate_string($db_username)
  validate_string($db_password)
  validate_string($imap_host)
  validate_string($des_key)
  validate_array($plugins)
  validate_string($support_url)
  validate_string($password_db_dsn)
  validate_string($password_query)

  $application_dir = "${install_dir}/roundcubemail-${version}"

  class { 'roundcube::package': }

  class { 'roundcube::plugins':
    package_dir => $package_dir,
    install_dir => $application_dir,
    require     => Class['roundcube::package'],
  }

  class { 'roundcube::config':
    application_dir => $application_dir,
    process         => $process,
    require         => Class['roundcube::package'],
  }
}
