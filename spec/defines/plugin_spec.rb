require 'spec_helper'

describe 'roundcube::plugin' do
  let(:title) { 'password' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:current_version) { '1.6.0' }
  let(:install_dir) { "/opt/roundcubemail-#{current_version}" }
  let(:config_file) { "#{install_dir}/plugins/password/config.inc.php" }
  let(:pre_condition) { <<-EOS
      file { ['/opt', '/var/cache/puppet/archives']: ensure => directory }
    EOS
  }
  
  describe 'by default' do
    let(:params) { {} }

    specify { should contain_concat(config_file) }
    specify { should contain_concat__fragment("#{config_file}__default_config").with_source("#{install_dir}/plugins/password/config.inc.php.dist") }
  end

  describe 'with custom configuration' do
    let(:params) { {:options_hash => {'password_db_dsn' => 'psql://somewhere/else'}} }

    specify { should contain_concat__fragment("#{config_file}__custom_config").with_content(/^\$config\['password_db_dsn'\] = 'psql:\/\/somewhere\/else';$/) }
  end

  describe 'should fail when plugin configuration is disabled' do
    let(:pre_condition) { <<-EOS
        file { ['/opt', '/var/cache/puppet/archives']: ensure => directory }
        
        class { 'roundcube':
          plugins_manage => false,
        }
      EOS
    }

    it do
      expect { should contain_concat(config_file) }.to raise_error(Puppet::Error, /conflicting parameters/)
    end
  end
end
