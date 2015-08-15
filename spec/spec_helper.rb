require 'puppetlabs_spec_helper/module_spec_helper'
require 'fixtures/modules/module_data/lib/hiera/backend/module_data_backend'

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
end
