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

        class { 'php': }
        -> class { 'roundcube': }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/var/www/roundcubemail/composer.json') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match /"prefer-stable":\s*true/ }
    end

    describe file('/var/www/roundcubemail/config/config.inc.php') do
      it { should be_file }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 440 }
    end

    describe command('php -l /var/www/roundcubemail/config/config.inc.php') do
      its(:stdout) { should match /No syntax errors/ }
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
                                 
        class { 'php': }
        -> class { 'roundcube':
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
      its(:content) { should match /^\$config\['imap_host'\] = 'ssl:\/\/localhost:993';$/ }
      its(:content) { should match /^\$config\['des_key'\] = 'beefbeefbeefbeefbeefbeef';$/ }
      its(:content) { should match /^\$config\['language'\] = 'en_US';$/ }
      its(:content) { should match /^\$config\['support_url'\] = 'http:\/\/example\.com\/helpdesk';$/ }
    end

    describe command('php -l /var/www/roundcubemail/config/config.inc.php') do
      its(:stdout) { should match /No syntax errors/ }
    end
  end

  context 'with custom template' do
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

        class { 'php': }
        -> class { 'roundcube':
          config_file_template => 'roundcube/config/options.php.erb',
          options_hash         => {
            'support_url' => 'http://example.com/',
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
      its(:content) { should match /^\$config\['support_url'\] = 'http:\/\/example\.com\/';$/ }
    end

    describe command('php -l /var/www/roundcubemail/config/config.inc.php') do
      its(:stdout) { should match /No syntax errors/ }
    end
  end

  context 'with 1.7.x' do
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

        class { 'php': }
        -> class { 'roundcube': 
          version => '1.7.1',
          checksum => '1e0382bcefd627ab0b6285d3181ddfba5b444fdcf6d49f33f5ea15fbf97864ef',
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/opt/roundcubemail-1.7.1/composer.json') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match /"prefer-stable":\s*true/ }
    end

    describe file('/opt/roundcubemail-1.7.1/config/config.inc.php') do
      it { should be_file }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 440 }
    end

    describe command('php -l /opt/roundcubemail-1.7.1/config/config.inc.php') do
      its(:stdout) { should match /No syntax errors/ }
    end

    describe file('/opt/roundcubemail-1.7.1/installer') do
      it { should_not be_directory }
    end

    describe file('/opt/roundcubemail-1.7.1/logs') do
      it { should be_directory }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 750 }
    end

    describe file('/opt/roundcubemail-1.7.1/temp') do
      it { should be_directory }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 750 }
    end

    describe file('/opt/roundcubemail-1.7.1/public_html') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end

    describe file('/var/www/roundcubemail/index.php') do
      it { should be_file }
    end

    describe file('/var/www/roundcubemail/config') do
      it { should_not be_directory }
    end
  end
end
