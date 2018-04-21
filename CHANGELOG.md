## 2018-04-21 - Release 3.2.0

Quick update to support the most recent 4.x concat version ([#8](https://github.com/tohuwabohu/puppet-roundcube/pull/8)).

## 2017-11-26 - Release 3.1.0
### Summary

This update contains a couple of major improvements which should not break any backward compatibility

* Update to roundcube 1.3.3 mainly because of security update
* Update of the test infrastructure (gems and more test platforms)
* Add support of Puppet 5; in turn support of Puppet 3 has been dropped
* Add support of Debian 9 and Ubuntu 16.04

**Note:** this will be the last release supporting `camptocamp-archive`, the next major release will drop the support.

## 2016-09-07 - Release 3.0.0
### Summary

Add support for both well-known archive providers, [puppet-archive](https://forge.puppetlabs.com/puppet/archive) and
[camptocamp-archive](https://forge.puppetlabs.com/camptocamp/archive)
([#6](https://github.com/tohuwabohu/puppet-roundcube/pull/6)).

**Note:** As part of this change, the dependency on `camptocamp-archive` has been dropped so anyone using
librarian-puppet can freely select the archive provider of choice. By default this module will use `camptocamp-archive`.

## 2016-04-24 - Release 2.2.0
### Summary

Update the default roundcube version to 1.1.5; packages are now sourced from [http://github.com] instead of
[http://downloads.sourceforge.net].

## 2016-03-25 - Release 2.1.0
### Summary

Update the default roundcube version to 1.1.4 and add support for Puppet 4.

#### Improvements

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

## 2015-09-06 - Release 2.0.3
### Summary

This release fixes two issues with roundcube 1.1.2

* [#1](https://github.com/tohuwabohu/puppet-roundcube/issues/1): maintenance cron job is too verbose
* [#2](https://github.com/tohuwabohu/puppet-roundcube/issues/2): two conflicting pear dependencies installed by composer prevent the sending of emails

## 2015-08-30 - Release 2.0.2
### Summary

Fixes a bug which causes plugins from the plugin repository not being enabled as expected.

## 2015-08-30 - Release 2.0.0
### Summary

Major rewrite after upgrading from Roundcube 0.9.x to 1.0.0.
