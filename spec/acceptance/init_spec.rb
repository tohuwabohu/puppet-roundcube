require 'spec_helper_acceptance'

describe 'roundcube' do
  context 'with default configuration' do
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

        package { 'git':
          ensure => installed,
        }

        package { 'php5-cli':
          ensure => installed,
        }

        class { 'roundcube': }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/var/www/roundcubemail/config/config.inc.php') do
      it { should be_file }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 440 }
    end

    describe file('/var/www/roundcubemail/installer') do
      it { should_not be_directory }
    end

    describe file('/var/www/roundcubemail/logs') do
      it { should be_directory }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 750 }
    end

    describe file('/var/www/roundcubemail/temp') do
      it { should be_directory }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 750 }
    end

    describe file('/etc/cron.daily/roundcube-cleandb') do
      it { should be_file }
      it { should be_readable }
      it { should be_executable }
    end
  end

  context 'with custom configuration' do
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

        package { 'git':
          ensure => installed,
        }

        package { 'php5-cli':
          ensure => installed,
        }

        class { 'roundcube':
          imap_host    => 'ssl://localhost',
          imap_port    => 993,
          des_key      => 'beefbeefbeefbeefbeefbeef',
          options_hash => {
            'language'    => 'en_US', # override auto-detection
            'support_url' => 'http://example.com/helpdesk',
          },
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/var/www/roundcubemail/config/config.inc.php') do
      its(:content) { should match /^\$config\['default_host'\] = 'ssl:\/\/localhost';$/ }
      its(:content) { should match /^\$config\['default_port'\] = '993';$/ }
      its(:content) { should match /^\$config\['des_key'\] = 'beefbeefbeefbeefbeefbeef';$/ }
      its(:content) { should match /^\$config\['language'\] = 'en_US';$/ }
      its(:content) { should match /^\$config\['support_url'\] = 'http:\/\/example\.com\/helpdesk';$/ }
    end
  end
end
