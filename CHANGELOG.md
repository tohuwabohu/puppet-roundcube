# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v5.0.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v5.0.1) (2025-10-17)

### Changed

- Actually fix `puppetlabs/stdlib` deprecation warnings

## [v5.0.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v5.0.0) (2025-10-12)

### Changed

- Fix `puppetlabs/stdlib` deprecation warnings; this requires to bump the minimum version to 9.x 

## [v4.0.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v4.0.0) (2025-10-12)
      
This release contains a major change by dropping the dependency on the archived `willdurand/composer` and standardizing
on `puppet/archive` for downloading roundcube.

This version still supports `puppetlabs/stdlib` down to 4.6.0.

### Changed

- Standardize on `puppet/archive` for downloading roundcube; new explicit dependency 

### Added

- Parameter `archive_cleanup` to control if the downloaded file should be removed after extraction. By default `false`
  to stay consistent with the existing behaviour.

### Removed

- Support for `camptocamp/archive` and `nanliu/archive` for downloading roundcube
- Parameter `archive_provider` due to standardization on `puppet/archive`
- Dependency on archived `willdurand/composer`; it's expected to be provided, for instance by `puppet/php`
- Parameter `composer_manage` due to removed support for `willdurand/composer`

## [v3.8.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.8.1) (2025-10-12)

### Added

- OS compatibility: add Debian 12 and Ubuntu 24.04
                        
## [v3.8.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.8.0) (2024-04-20)

### Changed
             
- Dependency puppetlabs/stdlib: replace deprecated `uriescape` function 
- CI: Support Puppet 8
- CI: Remove EOL'ed Puppet 6 from test matrix

## [v3.7.2](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.7.2) (2024-02-18)

- Add support for puppetlabs/stdlib 9.x

## [v3.7.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.7.1) (2023-06-24)

### Changed

- OS compatibility: remove Debian 9, add Debian 11, remove Ubuntu 18.04, add Ubuntu 22.04

## [v3.7.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.7.0) (2023-06-22)

### Changed

- Replace deprecated `is_` and `validate_` puppetlabs/stdlib functions with Puppet data types; as data types are 
  available since Puppet 5, this is considered a backward-compatible change

## [v3.6.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.6.1) (2023-06-19)

### Improved

- unit-tests: Removed EOL'd Puppet 5 from test matrix
- unit-tests: Bumped Puppet 6 Ruby version to 2.7

### Updated

- Puppet module dependencies: puppetlabs-concat and -stdlib

## [v3.6.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.6.0) (2022-10-08)
           
### Summary

Add support for [roundcube 1.6](https://github.com/roundcube/roundcubemail/releases/tag/1.6.0). As there are breaking 
changes, please make sure you've read the changelog. Also don't forget to apply the database changes.
                    
### Added

- Allow to configure the user used to execute the composer command; defaults to `root` ([#38](https://github.com/tohuwabohu/puppet-roundcube/issues/38))

### Changed

- Make module compatible with roundcube 1.6 by renaming `default_host` to `imap_host` and merging `default_port` into 
  `imap_host`.
- Fail Puppet run if 1.6 is used with outdated parameters (e.g. `smtp_server`)

## [v3.5.3](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.5.3) (2022-09-21)
              
Note: this release has been removed from the forge as it was incompatible with version 1.6 of roundcube.

### Changed

- Update roundcube version to 1.6.0 from 1.4.4; this also fixed the composer error complaining about missing plugins in 
  allow-plugins list
- Mark latest versions of stdlib and concat dependencies as compatible
- Replace discontinued plugin johndoh/markasjunk2 in acceptance tests with roundcube/rcsample

## [v3.5.2](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.5.2) (2021-02-13)
                                                                      
### Changed

- Mark all versions of Puppet 7 as supported

## [v3.5.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.5.1) (2021-02-13)
           
### Deprecated

- `camptocamp` as default for `archive_provider`; will be replaced with `puppet` as per deprecation notice on 
  [camptocamp/archive](https://forge.puppet.com/modules/camptocamp/archive)  

### Changed
               
- Rename default branch to `main`
- Migrate from travis-ci.org to Github Actions due to pending shutdown :sob:
- Add Puppet 7 unit tests
- Replace Ubuntu 16.04 with Ubuntu 20.04 in acceptance test matrix
- Mark latest versions of stdlib and concat dependencies as compatible

## [v3.5.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.5.0) (2020-06-13)

### Changed

- Update the default version of roundcube from 1.3.3 to 1.4.4
- Update the test matrix to run agains Puppet 5 and 6; mark module as compatible with Puppet 6 
- Update the acceptance test matrix: replaced Debian 7/8 with Debian 9/10 and replaced Ubuntu 12.04/14.04 with 16.04/18.04

### Added

- Make compatible with FreeBSD ([#16](https://github.com/tohuwabohu/puppet-roundcube/pull/16)).

## [v3.4.2](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.4.2) (2019-10-13)

### Added

- Add parameter `$cronjobs_manage` ([#15](https://github.com/tohuwabohu/puppet-roundcube/pull/15)).

## [v3.4.1](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.4.1) (2018-06-12) 

This is a bugfix release to fix an unintended side-effect caused by ([#12](https://github.com/tohuwabohu/puppet-roundcube/pull/12)):
defining at least one `roundcube::plugin` resource whilst leaving the `plugins` parameter untouched did result in a 
broken php configuration file.

This has been fixed by ...
* Restoring the original behaviour wrt. the `plugins` parameter
* Introducing a new `plugins_manage` parameter to explicitly control the plugin configuration. If this is set to `false` 
  it is expected that the plugin list is managed separated and hence the module will bail out if there is any plugin 
  configuration detected, either via the `plugins` parameter or via the `roundcube::plugin` resource. The parameter is 
  set to `true` by default.

## [v3.4.0](https://github.com/tohuwabohu/puppet-roundcube/tree/v3.4.0) (2018-06-10)

Allow to make puppet composer module optional ([#13](https://github.com/tohuwabohu/puppet-roundcube/pull/13)).

## 2018-06-03 - Release 3.3.0

Two minor improvements

* Add `archive_proxy_server` parameter to configure proxy server when archive module is being used ([#10](https://github.com/tohuwabohu/puppet-roundcube/pull/10))
* Allow `plugins` configuration to be managed separately outside of this module ([#12](https://github.com/tohuwabohu/puppet-roundcube/pull/12))

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
