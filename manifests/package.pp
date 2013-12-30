# Class: roundcube::package
#
# The Roundcube software package.
#
class roundcube::package($version, $md5) {
  validate_string($version)
  validate_string($md5)
}
