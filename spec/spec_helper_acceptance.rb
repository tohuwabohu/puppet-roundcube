require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_module_on(hosts)
install_module_from_forge_on(hosts, 'puppetlabs-stdlib', '= 4.25.1')
install_module_from_forge_on(hosts, 'puppetlabs-concat', '= 4.2.1')
install_module_from_forge_on(hosts, 'willdurand-composer', '= 1.2.6')
install_module_from_forge_on(hosts, 'camptocamp-archive', '= 0.8.1')
# test dependencies
install_module_from_forge_on(hosts, 'puppetlabs-apache', '= 3.1.0')

RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do
    logger.info("Using Puppet version #{(on default, 'puppet --version').stdout.chomp}")
  end
end
