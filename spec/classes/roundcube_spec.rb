require 'spec_helper'

describe 'roundcube' do
  let(:title) { 'roundcube' }
  let(:facts) { {:postgres_default_version => '9.2', :operatingsystem => 'Debian', :osfamily => 'Debian'} }

  describe 'installs default version' do
    let(:params) { {} }

    it { should contain_class('roundcube::package').with_version('0.8.5') }
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

  describe 'creates symbolic link to current version' do
    let(:params) { {} }

    it { should contain_file('/opt/roundcubemail-current').with_ensure('link').with_target('/opt/roundcubemail-0.8.5') }
  end

  describe 'manages a database' do
    let(:params) { {} }

    it { should contain_class('roundcube::database') }
  end

  describe 'creates a database configuration file' do
    let(:params) { {} }

    it { should contain_file('/opt/roundcubemail-0.8.5/config/db.inc.php') }
  end

  describe 'creates database configuration file with proper database url' do
    let(:params) { {:db_host => 'example.com', :db_name => 'name', :db_user => 'user', :db_password => 'foo<bar'} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/db.inc.php').send(:parameters)[:content]
      content.should match('pgsql://user:foo%3Cbar@example.com/name')
    end
  end

  describe 'creates configuration file with proper imap host' do
    let(:params) { {:imap_host => 'ssl://localhost'} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['default_host'\\] = 'ssl://localhost';")
    end
  end

  describe 'creates configuration file with proper imap port' do
    let(:params) { {:imap_port => 993} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['default_port'\\] = 993;")
    end
  end

  describe 'creates configuration file with salt' do
    let(:params) { {:des_key => 'some-salt'} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['des_key'\\] = 'some-salt';")
    end
  end

  describe 'creates configuration file with enabled plugins' do
    let(:params) { {:plugins => ['plugin1', 'plugin2']} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['plugins'\\] = array\\('plugin1', 'plugin2'\\);")
    end
  end

  describe 'creates configuration file with support url' do
    let(:params) { {:support_url => 'http://example.com'} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['support_url'\\] = 'http://example.com';")
    end
  end

  describe 'create configuration file with language auto-detection' do
    let(:params) { {} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['language'\\] = null;")
    end
  end

  describe 'create configuration file with custom language' do
    let(:params) { {:language => 'en_US'} }

    it do
      content = catalogue.resource('file', '/opt/roundcubemail-0.8.5/config/main.inc.php').send(:parameters)[:content]
      content.should match("\\$rcmail_config\\['language'\\] = 'en_US';")
    end
  end
end
