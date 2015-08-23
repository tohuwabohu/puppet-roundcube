require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  ignore_list = %w(junit log spec tests vendor)

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      if fact('operatingsystem') == 'Ubuntu'
        on host, 'apt-get update' # Ubuntu removes outdated packages; this ensures the index is fresh
      end

      # Install module
      copy_module_to(host, :source => proj_root, :module_name => 'roundcube', :ignore_list => ignore_list)

      # Install dependencies
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version 4.8.0')
      on host, puppet('module', 'install', 'ripienaar-module_data', '--version 0.0.3')
      on host, puppet('module', 'install', 'camptocamp-archive', '--version 0.3.1')

      # Install test dependencies
      on host, puppet('module', 'install', 'puppetlabs-apache', '--version 1.6.0')
    end
  end
end
