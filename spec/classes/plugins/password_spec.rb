require 'spec_helper'

describe 'roundcube::plugins::password' do
  let (:pre_condition) do
    'include roundcube'
  end

  let(:facts) { {:postgres_default_version => '9.2', :operatingsystem => 'Debian', :osfamily => 'Debian'} }
  let(:current_version) { '1.1.2' }
  let(:install_dir) { "/opt/roundcubemail-#{current_version}" }
  let(:password_config_file) { "#{install_dir}/plugins/password/config.inc.php" }

  describe 'by default' do
    let(:params) { {} }

    specify { should contain_file(password_config_file).with_source("#{install_dir}/plugins/password/config.inc.php.dist") }
  end

  describe 'create password plugin configuration file with different minimal length' do
    let(:params) { {:password_minimum_length => 16} }

    specify { should contain_file_line("#{password_config_file}__password_minimum_length").with_line(/^\$config\['password_minimum_length'\] = 16;/) }
  end

  describe 'create password plugin configuration file with non-alpha characters required' do
    let(:params) { {:password_require_nonalpha => true} }

    specify { should contain_file_line("#{password_config_file}__password_require_nonalpha").with_line(/^\$config\['password_require_nonalpha'\] = true;$/) }
  end

  describe 'create password plugin configuration file with custom database connection' do
    let(:params) { {:password_db_dsn => 'psql://somewhere/else'} }

    specify { should contain_file_line("#{password_config_file}__password_db_dsn").with_line(/^\$config\['password_db_dsn'\] = 'psql:\/\/somewhere\/else';$/) }
  end

  describe 'create password plugin configuration file with custom password query' do
    let(:params) { {:password_query => 'SELECT foobar'} }

    specify { should contain_file_line("#{password_config_file}__password_query").with_line(/^\$config\['password_query'\] = 'SELECT foobar';$/) }
  end
end
