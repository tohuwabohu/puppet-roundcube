require 'spec_helper'

describe 'roundcube' do
    let(:title) { 'roundcube' }

  describe 'installs default version' do
    let(:params) { {} }

    it { should contain_class('roundcube::package').with_version('0.9.5') }
  end

  describe 'installs custom version' do
    let(:params) { {:version => '1.2.3'} }

    it { should contain_class('roundcube::package').with_version('1.2.3') }
  end

  describe 'uses custom archive hash' do
    let(:params) { {:md5 => '123'} }

    it { should contain_class('roundcube::package').with_md5('123') }
  end

  describe 'stores packages in custom directory' do
    let(:params) { {:package_dir => '/somewhere/else'} }

    it { should contain_class('roundcube::package').with_package_dir('/somewhere/else') }
  end

  describe 'installs application in custom directory' do
    let(:params) { {:install_dir => '/somewhere/else'} }

    it { should contain_class('roundcube::package').with_install_dir('/somewhere/else') }
  end
end
