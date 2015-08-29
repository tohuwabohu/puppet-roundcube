# == Class: roundcube::workarounds::broken_plugin_installer
#
# The latest release 0.1.6 of the plugin_installer contains a bug which prevents the installation of plugins via
# composer. The workaround is to upgrade the plugin installer to the latest commit.
#
# See http://trac.roundcube.net/ticket/1490471.
#
class roundcube::workarounds::broken_plugin_installer {

  include composer
  include roundcube

  $application_dir = $roundcube::install::target
  $composer_package_name = 'roundcube/plugin-installer'
  $composer_package_version = 'dev-master#7320d96810f8644eb2b4afef60726198aed34011'

  exec { "${roundcube::composer_command_name} require ${composer_package_name}:${composer_package_version} --update-no-dev --ignore-platform-reqs":
    unless      => "${roundcube::composer_command_name} show --installed ${composer_package_name} ${composer_package_version}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
  }
}
