# == Class: roundcube::workarounds::conflicting_pear_dependency
#
# Both - `pear/net_smtp` and `pear/mail_mime` depend in more recent versions on `pear/pear-core-minimal` which
# conflicts with the `pear-pear.php.net/PEAR` dependency. Installing older version of the modules to ensure
# `pear-core-minimal` is not pulled in.
#
#
class roundcube::workarounds::conflicting_pear_dependency {

  include composer
  include roundcube

  $application_dir = $roundcube::install::target
  $composer_net_smtp_package_name = 'pear/net_smtp'
  $composer_net_smtp_package_version = '1.6.3'
  $composer_mail_mime_package_name = 'pear/mail_mime'
  $composer_mail_mime_package_version = '1.8.9'

  exec { "${roundcube::composer_command_name} require ${composer_net_smtp_package_name}:${composer_net_smtp_package_version} --update-no-dev --update-with-dependencies":
    unless      => "${roundcube::composer_command_name} show --installed ${composer_net_smtp_package_name} ${composer_net_smtp_package_version}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
    require     => Class['roundcube::install'],
  }

  exec { "${roundcube::composer_command_name} require ${composer_mail_mime_package_name}:${composer_mail_mime_package_version} --update-no-dev --update-with-dependencies":
    unless      => "${roundcube::composer_command_name} show --installed ${composer_mail_mime_package_name} ${composer_mail_mime_package_version}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
    require     => Class['roundcube::install'],
  }
}
