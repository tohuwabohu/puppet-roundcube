require 'spec_helper_acceptance'

describe 'with Apache + SQLite' do
  let(:manifest) { <<-EOS
      $required_directories = [
        '/opt',
        '/var/cache/puppet',
        '/var/cache/puppet/archives',
        '/var/www',
      ]

      file { $required_directories:
        ensure => directory,
      }

      class { 'apache':
         mpm_module => 'prefork',
         docroot    => '/var/www/roundcubemail',
      }

      class { 'apache::mod::php': }

      package { 'php5-sqlite':
        ensure  => installed,
        require => Class['apache'],
      }

      class { 'roundcube':
        db_type => 'sqlite',
        db_host => '',
        db_name => '/tmp/roundcube.db?mode=0646',
        db_username => '',
        db_password => '',
      }
    EOS
  }

  specify 'should provision with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  describe command('curl -I http://localhost') do
    its(:stdout) { should match /HTTP\/1.1 200 OK/ }
  end

  describe command('curl http://localhost') do
    its(:stdout) { should match /Welcome to Roundcube Webmail/ }
  end
end
