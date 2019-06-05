<!--
This file is part of the doubledog-systemd Puppet module.
Copyright 2018-2019 John Florian
SPDX-License-Identifier: GPL-3.0-or-later

Template

## [VERSION] DATE/WIP
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

-->

# Change log

All notable changes to this project (since v2.2.0) will be documented in this file.  The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [2.4.0] WIP
### Added
- Fedora 30 support
- Puppet 6 compatibility
- parameters for Hiera driven declarations:
    - `systemd::mounts`
    - `systemd::units`
- documentation for:
    - `systemd_escaped_mount_path` function
    - `Systemd::Eventlist` data type
    - `Systemd::Flexsize` data type
    - `Systemd::Period` data type
    - `Systemd::Rate` data type
    - `Systemd::Size` data type
    - `Systemd::Unitlist` data type
### Changed
- `validate_absolute_path()` function to `Stdlib::Absolutepath` data type
- Absolute namespace references have been eliminated.
### Deprecated
### Removed
### Fixed
### Security

## [2.3.0] 2019-03-21
### Added
- Fedora 29 support
### Changed
- switch from Hiera 4 to Hiera 5
- dependency on `doubledog/ddolib` now expects 1 >= version < 2
- dependency on `puppetlabs/stdlib` now allows version 5
### Removed
- Fedora 26-27 support

## [2.2.0 and prior] 2018-12-15

This and prior releases predate this project's keeping of a formal CHANGELOG.  If you are truly curious, see the Git history.
