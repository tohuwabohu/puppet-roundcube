require 'spec_helper_acceptance'

describe 'roundcube::plugins::password' do
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
      class { 'roundcube::plugins::password': }
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
