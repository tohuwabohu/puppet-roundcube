# Class: roundcube::plugins
#
# Manage Roundcube plugins.
#
class roundcube::plugins($package_dir, $install_dir) {
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)

  # plugin version 1.6, 22nd October 2013
  archive { 'markasjunk2':
    ensure        => present,
    digest_string => '96d6ded230ca1aaf9900036e67446bd3',
    url           => 'http://www.tehinterweb.co.uk/roundcube/plugins/markasjunk2.tar.gz',
    target        => "${install_dir}/plugins",
    src_target    => $package_dir,
    timeout       => 600,
    require       => File[$package_dir],
  }
}