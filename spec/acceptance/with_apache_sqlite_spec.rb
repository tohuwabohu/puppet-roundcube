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

      class { 'roundcube':
        db_dsn => 'sqlite:////tmp/roundcube.db?mode=0646',
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
