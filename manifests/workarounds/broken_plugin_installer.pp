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
  $composer_update_cmd = "${roundcube::composer_command_name} update --no-dev --ignore-platform-reqs"

  augeas { "${application_dir}/composer.json__require_roundcube_plugin_installer":
    lens    => 'Json.lns',
    incl    => "${application_dir}/composer.json",
    changes => [
         "set dict/entry[. = 'require']/dict/entry[. = 'roundcube/plugin-installer']/string dev-master",
    ],
    require => Class['roundcube::install'],
  }

  ->

  exec { $composer_update_cmd:
    unless      => "${composer_update_cmd} --dry-run 2>&1 | grep -q -F 'Nothing to install or update'",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
  }
}
