RSpec.configure do |c|
  c.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    # default
    :networking      => {
      :ip => '127.0.0.1'
    },

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
