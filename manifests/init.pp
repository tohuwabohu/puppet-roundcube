# == Class: roundcube
#
# Install and manage the Roundcube webmail application.
#
# === Parameters
#
# [*version*]
#   Set the version of the web application to be installed.
#
# [*checksum*]
#   Set the checksum of the web application's archive file.
#
# [*checksum_type*]
#   Set the type of checksum.
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
# [*exec_paths*]
#   Set the paths used to search for executables when invoking exec resources.
#
# [*composer_command_name*]
#   Set name of the composer executable. It is expected to find the executable via the `exec_paths`.
#
# [*composer_disable_git_ssl_verify*]
#   Set to `true` to disable the SSL certificate check when cloning a git repository. Only required when the CA
#   presented by the git server is not trusted by this host. See https://stackoverflow.com/q/21181231.
#
# [*document_root*]
#   Set the directory which should act as document root. It will be sym-linked to the current installation.
#
# [*document_root_manage*]
#   Whether to manage the `document_root` file resource or not: either `true` or `false`.
#
# [*db_dsn*]
#   Set the database data source name (DSN) to be used when connecting to the database. Setting this parameter will
#   override the other `db_*` parameters. See http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php for
#   examples.
#
#   Note: please make sure any special characters are properly encoded (e.g. use stdlib's uriescape function).
#
# [*db_type*]
#   Set the type database (e.g. mysql or pgsql). See http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
#   for a reference of supported types. Defaults to `pgsql`.
#
# [*db_name*]
#   Set the name of the database. Defaults to `roundcubemail`.
#
# [*db_host*]
#   Set the hostname where the database is running. Puppet can only manage databases on the local host. Defaults to
#   `localhost`.
#
# [*db_username*]
#   Set the username used to connect to the database. Defaults to `roundcube`.
#
# [*db_password*]
#   Set the password used to authenticate the database user. The module will encode any special characters. Defaults to
#   `pass`.
#
# [*imap_host*]
#   Set the IMAP mail host chosen to perform the log-in (`default_host` configuration parameter). Defaults to
#   `localhost`.
#
# [*imap_port*]
#   Set the TCP port used for IMAP connections. Defaults to `143`.
#
# [*des_key*]
#   Set key used to encrypt the users' IMAP password which is stored in the session record (and the client cookie if
#   remember password is enabled). Please provide a string of exactly 24 chars. YOUR KEY MUST BE DIFFERENT THAN THE
#   SAMPLE VALUE FOR SECURITY REASONS.
#
# [*plugins*]
#   List of plugins to be enabled. Only bundled plugins are supported. Enable plugin repository ones via the
#   `roundcube::plugin` resource.
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
  $version,
  $checksum,
  $checksum_type,
  $process,

  $package_dir,
  $install_dir,
  $exec_paths,
  $composer_command_name,
  $composer_disable_git_ssl_verify,
  $document_root,
  $document_root_manage,

  $db_dsn       = undef,
  $db_type      = 'pgsql',
  $db_name      = 'roundcubemail',
  $db_host      = 'localhost',
  $db_username  = 'roundcube',
  $db_password  = 'pass',

  $imap_host    = 'localhost',
  $imap_port    = 143,
  $des_key      = 'rcmail-!24ByteDESkey*Str',
  $plugins      = [],

  $options_hash = {},
) {
  validate_string($version)
  validate_string($checksum)
  validate_string($checksum_type)
  validate_string($process)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
  validate_string($composer_command_name)
  validate_bool($composer_disable_git_ssl_verify)
  validate_absolute_path($document_root)
  if $document_root_manage !~ /^true|false$/ {
    fail("Class[Roundcube]: document_root_manage must be either true or false, got '${document_root_manage}'")
  }
  validate_string($db_type)
  validate_string($db_name)
  validate_string($db_host)
  validate_string($db_username)
  validate_string($db_password)
  validate_string($imap_host)
  validate_string($des_key)
  validate_array($plugins)
  validate_hash($options_hash)

  $composer_git_ssl_no_verify = bool2num($composer_disable_git_ssl_verify)
  $composer_exec_environment = [
    "HOME=${::root_home}",
    'COMPOSER_NO_INTERACTION=1',
    "GIT_SSL_NO_VERIFY=${composer_git_ssl_no_verify}",
  ]

  class { 'roundcube::install': } ->
  class { 'roundcube::config': } ~>
  class { 'roundcube::service': }
}
