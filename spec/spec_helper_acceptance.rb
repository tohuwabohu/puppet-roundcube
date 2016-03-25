require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['BEAKER_PROVISION'] == 'no'
  hosts.each do |_|
    install_puppet
  end
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  ignore_list = %w(junit log spec tests vendor)

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      # Install module
      copy_module_to(host, :source => proj_root, :module_name => 'roundcube', :ignore_list => ignore_list)

      # Install dependencies
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version 4.11.0')
      on host, puppet('module', 'install', 'puppetlabs-concat', '--version 2.1.0')
      on host, puppet('module', 'install', 'willdurand-composer', '--version 1.1.1')
      on host, puppet('module', 'install', 'camptocamp-archive', '--version 0.8.1')

      # Install test dependencies
      on host, puppet('module', 'install', 'puppetlabs-apache', '--version 1.8.1')
    end
  end
end
