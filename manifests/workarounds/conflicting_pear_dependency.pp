# == Class: roundcube::workarounds::conflicting_pear_dependency
#
# Both - `pear/net_smtp` and `pear/mail_mime` depend in more recent versions on `pear/pear-core-minimal` which
# conflicts with the `pear-pear.php.net/PEAR` dependency. Installing the same version of the modules that are shipped
# in the complete archive available on sourceforge. This ensures `pear-core-minimal` is not pulled in.
#
#
class roundcube::workarounds::conflicting_pear_dependency {

  include composer
  include roundcube

  $application_dir = $roundcube::install::target
  $composer_net_smtp_package_name = 'pear/net_smtp'
  $composer_net_smtp_package_version = '1.6.2'
  $composer_mail_mime_package_name = 'pear/mail_mime'
  $composer_mail_mime_package_version = '1.8.9'

  augeas { "${application_dir}/composer.json__repositories_Net_SMTP":
    lens    => 'Json.lns',
    incl    => "${application_dir}/composer.json",
    changes => [
      "set dict/entry[. = 'repositories']/array/dict[4]/entry[2]/dict/entry[. = 'version']/string ${composer_net_smtp_package_version}",
      "set dict/entry[. = 'repositories']/array/dict[4]/entry[2]/dict/entry[. = 'name']/string ${composer_net_smtp_package_name}",
      "set dict/entry[. = 'repositories']/array/dict[4]/entry[2]/dict/entry[. = 'source']/dict/entry[. = 'reference']/string ${composer_net_smtp_package_version}",
    ],
    require => Class['roundcube::install'],
  }

  exec { "${roundcube::composer_command_name} require ${composer_net_smtp_package_name}:${composer_net_smtp_package_version} --update-no-dev --update-with-dependencies":
    unless      => "${roundcube::composer_command_name} show --installed ${composer_net_smtp_package_name} ${composer_net_smtp_package_version}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
    require     => Augeas["${application_dir}/composer.json__repositories_Net_SMTP"],
  }

  exec { "${roundcube::composer_command_name} require ${composer_mail_mime_package_name}:${composer_mail_mime_package_version} --update-no-dev --update-with-dependencies":
    unless      => "${roundcube::composer_command_name} show --installed ${composer_mail_mime_package_name} ${composer_mail_mime_package_version}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
    require     => Class['roundcube::install'],
  }
}
