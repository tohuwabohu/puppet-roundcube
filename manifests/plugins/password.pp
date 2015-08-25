# == Class: roundcube::plugins::password
#
# Configures the password plugin.
#
# === Parameters
#
# [*password_minimum_length*]
#   Set minimum lenght a new password must have. By default any length is accepted.
#
# [*password_require_nonalpha*]
#   Set to `true` to require the new password to contain a letter and punctuation character. By default `false`.
#
# [*password_force_new_user*]
#   Set to `true` to require new users having to change the password at their first login. By default `false`.
#
# [*password_db_dsn*]
#   Set PEAR database DSN for performing the query. By default the Roundcube DB settings are used.
#
# [*password_query*]
#   Set the SQL query used to change the password.
#
# [*config_file_template*]
#   Set the path to a custom template file. By default, the default configuration shipped by with plugin is used and
#   only parameters listed in the manifest are controlled.
#
# [*options_hash*]
#   Any options to be used in the custom template file.
#
# === Copyright
#
# Copyright 2015 Martin Meinhold, unless otherwise noted.
#
class roundcube::plugins::password (
  $password_minimum_length   = 0,
  $password_require_nonalpha = false,
  $password_force_new_user   = false,
  $password_db_dsn           = '',
  $password_query            = 'SELECT update_passwd(%c, %u)',
  # Support custom configuration file ...
  $config_file_template      = undef,
  $options_hash              = {},
) {
  validate_integer($password_minimum_length)
  validate_bool($password_require_nonalpha)
  validate_bool($password_force_new_user)
  validate_string($password_db_dsn)
  validate_string($password_query)
  validate_hash($options_hash)

  require roundcube::install

  $application_dir = $roundcube::install::target
  $config_file = "${application_dir}/plugins/password/config.inc.php"

  File {
    owner => $roundcube::process,
    group => $roundcube::process,
    mode  => '0440',
  }

  if empty($config_file_template) {
    file { $config_file:
      source  => "${application_dir}/plugins/password/config.inc.php.dist",
      replace => false,
    }

    File_line {
      path => $config_file,
    }

    file_line { "${config_file}__password_minimum_length":
      match => '^\$config\[\'password_minimum_length\'\]\s*=.*;$',
      line  => "\$config['password_minimum_length'] = ${password_minimum_length};",
    }

    file_line { "${config_file}__password_require_nonalpha":
      match => '^\$config\[\'password_require_nonalpha\'\]\s*=.*;$',
      line  => "\$config['password_require_nonalpha'] = ${password_require_nonalpha};",
    }

    file_line { "${config_file}__password_force_new_user":
      match => '^\$config\[\'password_force_new_user\'\]\s*=.*;$',
      line  => "\$config['password_force_new_user'] = ${password_force_new_user};",
    }

    file_line { "${config_file}__password_db_dsn":
      match => '^\$config\[\'password_db_dsn\'\]\s*=.*;$',
      line  => "\$config['password_db_dsn'] = '${password_db_dsn}';",
    }

    file_line { "${config_file}__password_query":
      match => '^\$config\[\'password_query\'\]\s*=.*;$',
      line  => "\$config['password_query'] = '${password_query}';",
    }
  }
  else {
    file { $config_file:
      content => template($config_file_template),
    }
  }
}
