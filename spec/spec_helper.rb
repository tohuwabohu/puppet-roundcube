RSpec.configure do |c|
  c.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    # archive
    :path            => '/usr/bin',

    # concat
    :concat_basedir  => '/path/to/dir',

    # wget
    :kernel          => 'deadbeef',
    :operatingsystem => 'Debian',

    # roundcube
    :root_home       => '/root',
  }
end
