require 'spec_helper_acceptance'

describe 'roundcube::plugin' do
  context 'bundled plugin with default configuration' do
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

        class { 'roundcube':
          plugins => [
            'password',
          ],
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/var/www/roundcubemail/plugins/password/config.inc.php') do
      it { should be_file }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 440 }
    end
  end

  context 'bundled plugin with configuration parameters' do
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

        class { 'roundcube': }
        roundcube::plugin { 'password':
          options_hash => {
            'password_minimum_length'   => 16,
            'password_require_nonalpha' => true,
            'password_force_new_user'   => true,
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

    describe file('/var/www/roundcubemail/plugins/password/config.inc.php') do
      its(:content) { should match /^\$config\['password_minimum_length'\] = '16';$/ }
    end
  end

  context 'plugin from repository' do
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

        class { 'roundcube': }
        roundcube::plugin { 'johndoh/markasjunk2':
          ensure => 'dev-release-1.9',
        }
      EOS
    }

    specify 'should provision with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    specify 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe file('/var/www/roundcubemail/plugins/markasjunk2') do
      it { should be_directory }
    end

    describe file('/var/www/roundcubemail/plugins/markasjunk2/config.inc.php') do
      it { should be_file }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
      it { should be_mode 440 }
    end
  end
end
