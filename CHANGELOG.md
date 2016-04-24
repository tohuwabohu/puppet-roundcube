##2016-04-24 - Release 2.2.0
###Summary

Update the default roundcube version to 1.1.5; packages are now sourced from [http://github.com] instead of
[http://downloads.sourceforge.net].

##2016-03-25 - Release 2.1.0
###Summary

Update the default roundcube version to 1.1.4 and add support for Puppet 4.

####Improvements

* Replace [ripienaar/module_data](https://forge.puppetlabs.com/ripienaar/module_data) with `params.pp`; the module is
  unlikly to work with Puppet 4 (see [Native Puppet 4 Data in Modules](https://www.devco.net/archives/2016/01/08/native-puppet-4-data-in-modules.php))
  and in order to not break Puppet 3 support it is easier to just stick with a simple `params.pp` for the moment.
* Set `composer_disable_git_ssl_verify` parameter to `false` by default; previously it was set to `true` for all Debian
  systems to ensure the bootstrapping of the roundcube app would work even though one of the roundcube git repositories
  was presenting a SSL certificate not matching the domain. But now the complete installer is used instead, so this flag
  is no longer required.

Furthermore, the test infrastructure has been overhauled:

* Bump gem dependencies to the latest version
* Bump Puppet module dependencies to the latest version
* Update travis test matrix and add support for Puppet 4
* Replace VirtualBox with Docker for acceptance tests
* Add Debian 8

##2015-09-06 - Release 2.0.3
###Summary

This release fixes two issues with roundcube 1.1.2

* [#1](https://github.com/tohuwabohu/puppet-roundcube/issues/1): maintenance cron job is too verbose
* [#2](https://github.com/tohuwabohu/puppet-roundcube/issues/2): two conflicting pear dependencies installed by composer prevent the sending of emails

##2015-08-30 - Release 2.0.2
###Summary

Fixes a bug which causes plugins from the plugin repository not being enabled as expected.

##2015-08-30 - Release 2.0.0
###Summary

Major rewrite after upgrading from Roundcube 0.9.x to 1.0.0.
