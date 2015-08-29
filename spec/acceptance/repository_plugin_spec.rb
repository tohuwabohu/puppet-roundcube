require 'spec_helper_acceptance'

describe 'roundcube::plugin' do
  context 'from plugin repository' do
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
  end
end
