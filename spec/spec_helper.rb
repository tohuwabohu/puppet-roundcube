require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    # archive
    :path            => '/usr/bin',

    # wget
    :kernel          => 'deadbeef',
    :operatingsystem => 'Debian',

    # roundcube
    :root_home       => '/root',
  }
end
