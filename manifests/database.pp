# Class: roundcube::database
#
# Manage the database used by the web application.
#
class roundcube::database($db_type, $db_name, $db_host, $db_user, $db_password) {
  validate_string($db_type)
  validate_string($db_name)
  validate_string($db_host)
  validate_string($db_user)
  validate_string($db_password)

  $manage_database = $db_host ? {
    'localhost' => true,
    default     => false,
  }

  if $manage_database {
    case $db_type {
      'postgresql': {
        postgresql::db { $db_name:
          user     => $db_user,
          password => $db_password,
        }
      }
      default: {
        fail "Database type '${db_type}' is not supported."
      }
    }
  }
}
