require 'spec_helper'

describe 'roundcube' do
    let(:title) { 'roundcube' }

  describe 'default installation' do
    let(:params) { {} }

    it { should contain_class('roundcube') }
  end
end
