##2016-03-XX - Release 2.1.0
###Summary

####Improvements

The test infrastructure has been overhauled:

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
