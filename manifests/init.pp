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
# [*document_root*]
#   Set the directory which should act as document root. It will be sym-linked to the current installation.
#
# [*document_root_manage*]
#   Whether to manage the `document_root` file resource or not: either `true` or `false`.
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
# [*support_url*]
#   Set an URL where a user can get support for this Roundcube installation. PLEASE DO NOT LINK TO THE ROUNDCUBE.NET
#   WEBSITE HERE!
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
  $document_root,
  $document_root_manage,

  $db_type,
  $db_name,
  $db_host,
  $db_username,
  $db_password,

  $imap_host,
  $imap_port,
  $des_key,
  $plugins,
  $support_url,

  $options_hash = { },
) {
  validate_string($version)
  validate_string($checksum)
  validate_string($checksum_type)
  validate_string($process)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
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
  validate_string($support_url)

  class { 'roundcube::install': } ->
  class { 'roundcube::config': } ~>
  class { 'roundcube::service': }
}
