# Class: roundcube::plugins
#
# Manage Roundcube plugins.
#
class roundcube::plugins($package_dir, $install_dir) {

  $plugin_name = 'markasjunk2'
  $original_name = 'Roundcube-Plugin-Mark-as-Junk-2-0.8.5'
  $plugin_dir = "${install_dir}/plugins"
  $download_url = 'https://github.com/JohnDoh/Roundcube-Plugin-Mark-as-Junk-2/archive/v0.8.5.tar.gz'

  archive { $plugin_name:
    ensure        => present,
    digest_string => 'a341c4aaeec4af6e21e70387e541b526',
    url           => $download_url,
    root_dir      => $original_name,
    target        => $plugin_dir,
    src_target    => $package_dir,
    timeout       => 600,
    require       => File[$package_dir],
    notify        => Exec["rename-roundcube-plugin-${plugin_name}"],
  }

  exec { "rename-roundcube-plugin-${plugin_name}":
    cwd     => $plugin_dir,
    command => "/bin/mv ${original_name} ${plugin_name}",
    creates => "${plugin_dir}/${plugin_name}",
  }
}