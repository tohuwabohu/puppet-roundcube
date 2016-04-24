require 'spec_helper'

describe 'roundcube' do
  let(:title) { 'roundcube' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:current_version) { '1.1.5' }
  let(:archive_name) { "roundcubemail-#{current_version}-complete" }
  let(:install_dir) { "/opt/roundcubemail-#{current_version}" }
  let(:config_file) { "#{install_dir}/config/config.inc.php" }
  let(:config_file_options_fragment) { "#{config_file}__options" }

  describe 'by default' do
    let(:params) { {} }

    specify { should contain_archive(archive_name) }
    specify { should contain_file('/var/www/roundcubemail').with(
        'ensure' => 'link',
        'target' => install_dir
      )
    }
  end

  describe 'installs custom version' do
    let(:params) { {:version => '1.2.3'} }

    specify { should contain_archive('roundcubemail-1.2.3-complete') }
  end

  describe 'uses custom archive checksum' do
    let(:params) { {:checksum => '123'} }

    specify { should contain_archive(archive_name).with_digest_string('123') }
  end

  describe 'uses custom archive checksum type' do
    let(:params) { {:checksum_type => 'sha1'} }

    specify { should contain_archive(archive_name).with_digest_type('sha1') }
  end

  describe 'stores packages in custom directory' do
    let(:params) { {:package_dir => '/somewhere/else'} }

    specify { should contain_archive(archive_name).with_src_target('/somewhere/else') }
  end

  describe 'installs application in custom directory' do
    let(:params) { {:install_dir => '/somewhere/else'} }

    specify { should contain_archive(archive_name).with_target('/somewhere/else') }
  end

  describe 'should create symbolic link to specified document_root' do
    let(:params) { {:document_root => '/path/to/document_root'} }

    specify { should contain_file('/path/to/document_root').with(
        'ensure' => 'link',
        'target' => install_dir
      )
    }
  end

  describe 'should not manage document_root if configured' do
    let(:params) { {:document_root_manage => false} }

    specify { should_not contain_file('/var/www/roundcubemail') }
  end

  describe 'should not accept document_root as a boolean string' do
    let(:params) { {:document_root_manage => 'false'} }

    specify do
      expect { should contain_archive(archive_name) }.to raise_error(Puppet::Error, /is not a boolean/)
    end
  end

  describe 'should not accept invalid document_root_ensure' do
    let(:params) { {:document_root_manage => 'invalid'} }

    specify do
      expect { should contain_archive(archive_name) }.to raise_error(Puppet::Error, /invalid/)
    end
  end

  describe 'creates database configuration file with proper database url' do
    let(:params) { {:db_host => 'example.com', :db_name => 'name', :db_username => 'user', :db_password => 'foo<bar'} }

    specify { should contain_concat__fragment(config_file_options_fragment).with_content(/^\$config\['db_dsnw'\] = 'pgsql:\/\/user:foo%3Cbar@example.com\/name';$/) }
  end

  describe 'creates configuration file with proper imap host' do
    let(:params) { {:imap_host => 'ssl://localhost'} }

    specify { should contain_concat__fragment(config_file_options_fragment).with_content(/^\$config\['default_host'\] = 'ssl:\/\/localhost';$/) }
  end

  describe 'creates configuration file with proper imap port' do
    let(:params) { {:imap_port => 993} }

    specify { should contain_concat__fragment(config_file_options_fragment).with_content(/^\$config\['default_port'\] = [']?993[']?;$/) }
  end

  describe 'creates configuration file with salt' do
    let(:params) { {:des_key => 'some-salt'} }

    specify { should contain_concat__fragment(config_file_options_fragment).with_content(/^\$config\['des_key'\] = 'some-salt';$/) }
  end

  describe 'creates configuration file with enabled plugins' do
    let(:params) { {:plugins => ['plugin1', 'plugin2']} }

    specify { should contain_roundcube__plugin('plugin1') }
    specify { should contain_roundcube__plugin('plugin2') }
  end

  describe 'create configuration file with custom language' do
    let(:params) { {:options_hash => {'language' => 'en_US'}} }

    specify { should contain_concat__fragment(config_file_options_fragment).with_content(/^\$config\['language'\] = 'en_US';$/) }
  end

  describe 'ensures the logs directory is writable by the webserver' do
    let(:params) { {:version => '1.0.0', :process => 'webserver'} }

    specify { should contain_file('/opt/roundcubemail-1.0.0/logs').with({
        'ensure' => 'directory',
        'owner'  => 'webserver',
        'group'  => 'webserver',
        'mode'   => '0640',
      })
    }
  end

  describe 'ensures the temp directory is writable by the webserver' do
    let(:params) { {:version => '1.0.0', :process => 'webserver'} }

    specify { should contain_file('/opt/roundcubemail-1.0.0/temp').with({
        'ensure' => 'directory',
        'owner'  => 'webserver',
        'group'  => 'webserver',
        'mode'   => '0640',
      })
    }
  end
end
