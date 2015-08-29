# == Define: roundcube:plugin
#
# Install and configure the given Roundcube plugin.
#
define roundcube::plugin (
  $ensure,
  $config_file_template = undef,
  $options_hash = {},
) {
  include composer
  include roundcube
  require roundcube::workarounds::broken_plugin_installer

  $application_dir = $roundcube::install::target
  $config_file = $roundcube::config::config_file

  exec { "${roundcube::composer_command_name} require ${name}:${ensure} --update-no-dev --ignore-platform-reqs":
    unless      => "${roundcube::composer_command_name} show --installed ${name} ${ensure}",
    cwd         => $application_dir,
    path        => $roundcube::exec_paths,
    environment => $roundcube::composer_exec_environment,
    require     => Class['roundcube::install'],
  }

  concat::fragment { "${config_file}__plugins_${title}":
    target  => $config_file,
    content => "  '${title}',",
    order   => '55',
  }
}
