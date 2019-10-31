<!--
This file is part of the doubledog-ddolib Puppet module.
Copyright 2017-2019 John Florian
SPDX-License-Identifier: GPL-3.0-or-later
-->

# systemd

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with systemd](#setup)
    * [What systemd affects](#what-systemd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with systemd](#beginning-with-systemd)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
    * [Data types](#data-types)
    * [Facts](#facts)
    * [Functions](#functions)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module lets you manage the configuration of systemd, its various daemons and perhaps most importantly, the nifty things you can via systemd units.

## Setup

### What systemd Affects

### Setup Requirements

### Beginning with systemd

## Usage

## Reference

**Classes:**

* [systemd](#systemd-class)
* [systemd::daemon](#systemddaemon-class)
* [systemd::journald](#systemdjournald-class)
* [systemd::logind](#systemdlogind-class)

**Defined types:**

* [systemd::mount](#systemdmount-defined-type)
* [systemd::unit](#systemdunit-defined-type)

**Data types:**

* [Systemd::Eventlist](#systemdeventlist-data-type)
* [Systemd::Flexsize](#systemdflexsize-data-type)
* [Systemd::Journald::Level](#systemdjournaldlevel-data-type)
* [Systemd::Logind::Event](#systemdlogindevent-data-type)
* [Systemd::Period](#systemdperiod-data-type)
* [Systemd::Rate](#systemdrate-data-type)
* [Systemd::Size](#systemdsize-data-type)
* [Systemd::Unit::Ensure](#systemdunitensure-data-type)
* [Systemd::Unitlist](#systemdunitlist-data-type)

**Facts:**

**Functions:**

* [systemd::escape](#systemdescape-function)


### Classes

#### systemd class

This class manages the systemd package.

##### `mounts`
A hash whose keys are mount resource names and whose values are hashes comprising the same parameters you would otherwise pass to the [systemd::mount](#systemdmount-defined-type) defined type.  The default is none.

##### `packages`
An array of package names needed for the systemd installation.  The default should be correct for supported platforms.

##### `units`
A hash whose keys are units resource names and whose values are hashes comprising the same parameters you would otherwise pass to the [systemd::unit](#systemdunit-defined-type) defined type.  The default is none.


#### systemd::daemon class

This class manages the systemd daemon.  Due to the nature of systemd being the init process (PID 1), there is very little to manage here.  This chiefly exists to serve as an event notification target so that the systemd daemon can reload its configuration when needed.


#### systemd::journald class

This class manages the systemd journald daemon.

##### `service`
The service name of the systemd journald daemon.

##### other parameters

For the following parameters, see `man journald.conf` for their use.  The parameter names have been normalized for Puppet so that `CamelCase` becomes `camel_case`.

Passing `undef` (the default value) causes the compiled defaults for the journald service to be used.  In other words, the setting will not be present in the configuration file.

* `compress`
* `forward_to_console`
* `forward_to_kmsg`
* `forward_to_syslog`
* `forward_to_wall`
* `max_file_sec` ([Systemd::Period](#systemdperiod-data-type))
* `max_level_console` ([Systemd::Journald::Level](#systemdjournaldlevel-data-type))
* `max_level_kmsg` ([Systemd::Journald::Level](#systemdjournaldlevel-data-type))
* `max_level_store` ([Systemd::Journald::Level](#systemdjournaldlevel-data-type))
* `max_level_syslog` ([Systemd::Journald::Level](#systemdjournaldlevel-data-type))
* `max_level_wall` ([Systemd::Journald::Level](#systemdjournaldlevel-data-type))
* `max_retention_sec` ([Systemd::Period](#systemdperiod-data-type))
* `rate_limit_burst` ([Systemd::Rate](#systemdrate-data-type))
* `rate_limit_interval_sec` ([Systemd::Rate](#systemdrate-data-type))
* `runtime_keep_free` ([Systemd::Size](#systemdsize-data-type))
* `runtime_max_file_size` ([Systemd::Size](#systemdsize-data-type))
* `runtime_max_files` ([Systemd::Size](#systemdsize-data-type))
* `runtime_max_use` ([Systemd::Size](#systemdsize-data-type))
* `seal`
* `split_mode`
* `storage`
* `sync_interval_sec` ([Systemd::Period](#systemdperiod-data-type))
* `system_keep_free` ([Systemd::Size](#systemdsize-data-type))
* `system_max_file_size` ([Systemd::Size](#systemdsize-data-type))
* `system_max_files` ([Systemd::Size](#systemdsize-data-type))
* `system_max_use` ([Systemd::Size](#systemdsize-data-type))
* `tty_path`


#### systemd::logind class

This class manages the systemd logind daemon.

##### `service`
The service name of the systemd logind daemon.

##### other parameters

For the following parameters, see `man logind.conf` for their use.  The parameter names have been normalized for Puppet so that `CamelCase` becomes `camel_case`.

Passing `undef` (the default value) causes the compiled defaults for the logind service to be used.  In other words, the setting will not be present in the configuration file.

* `handle_hibernate_key` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `handle_lid_switch` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `handle_lid_switch_docked` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `handle_power_key` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `handle_suspend_key` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `hibernate_key_ignore_inhibited`
* `holdoff_timeout_sec` ([Systemd::Period](#systemdperiod-data-type))
* `idle_action` ([Systemd::Logind::Event](#systemdlogindevent-data-type))
* `idle_action_sec` ([Systemd::Period](#systemdperiod-data-type))
* `inhibit_delay_max_sec` ([Systemd::Period](#systemdperiod-data-type))
* `kill_exclude_users`
* `kill_only_users`
* `kill_user_processes`
* `lid_switch_ignore_inhibited`
* `n_auto_vts`
* `power_key_ignore_inhibited`
* `remove_ipc`
* `reserve_vt`
* `runtime_directory_size` ([Systemd::Flexsize](#systemdflexsize-data-type))
* `suspend_key_ignore_inhibited`


### Defined types

#### systemd::mount defined type

This defined type manages a systemd mount unit configuration file.

Generally, it's advisable to simply use Puppet's `mount` resource type instead of this.  However, in some cases this definition has distinct advantages such as when there are inter-dependencies between a mount and other units.

Any option below whose name begins with `mnt_` is passed directly to the mount unit as a systemd parameter of the exact same name, sans the prefix.  This helps distinguish these from Puppet parameters (especially meta-) that share the same name.

##### `namevar` (REQUIRED)
An arbitrary identifier for the mount instance unless the *mnt_where* parameter is not set in which case this must provide the value normally set with the *mnt_where* parameter.

##### `mnt_what` (REQUIRED)
See `What=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#What=).  Takes an absolute path of a device node, file or other resource to mount.

##### `auto`
When `true`, an automount unit configuration file will be managed per *ensure* along with the standard mount unit configuration file.  The default is `false`.  See *enabled* for further effects and [SYSTEMD.AUTOMOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.automount.html) for additional details.

##### `ensure`
The [Systemd::Unit::Ensure](#systemdunitensure-data-type) data type specifying the state of mount-unit file (`present` (default) or `absent`) or the state of the mount-unit that file represents (`started` or `stopped`, both of which also imply `present`).  `running` may also be specified and will be treated identically to `started`.  It may help to think of these states from the systemd perspective where mounts are just one of many unit types.  Thus `started` means mounted and `stopped` means unmounted.

##### `enable`
Instance is to be enabled at boot.  The default is `undef` which means the mount won't be started as part of a target (i.e., *mnt_wantedby*).  Typically, this is what you'd want because it's generally better to use *mnt_before* instead so that this mount is ready by the time a target is reached.

When *auto* is `true` the main mount unit will be coerced to a disabled state while the automount unit will be as per *enable*.  This ensures that systemd will not start the mount when starting the target to which the mount unit is installed.  Rather, access to the mount point is required to start the mount unit -- hence mount-on-demand AKA systemd auto-mounting.  This is notable when changing the value of *auto* since when Puppet refreshes the state, it will try to first unmount the filesystem.  If the filesystem is already mounted and in use, the refresh could raise an error.

##### `mnt_after`
See `After=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Before=).  Configures ordering dependencies between systemd units.  Must match the [Systemd::Unitlist](#systemdunitlist-data-type) data type.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd start this mount after some other unit, you likely want to do the same via Puppet's sequencing meta-parameters.  It's your responsibility to ensure they agree.

##### `mnt_before`
See `Before=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Before=).  Configures ordering dependencies between systemd units.  Must match the [Systemd::Unitlist](#systemdunitlist-data-type) data type.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd start this mount before some other unit, you likely want to do the same via Puppet's sequencing meta-parameters.  It's your responsibility to ensure they agree.

##### `mnt_conflicts`
See `Conflicts=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Conflicts=).  Configures negative requirement dependencies. If a unit has a Conflicts= setting on another unit, starting the former will stop the latter and vice versa.  The default is `undef` meaning this setting is omitted from the unit file.

##### `mnt_default_dependencies`
See `DefaultDependencies=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#DefaultDependencies=).  Controls whether default dependencies will implicity be created for the unit.  Generally, only services involved with early boot or late shutdown should set this option to no.  The default is `undef` meaning this setting is omitted from the unit file.

##### `mnt_description`
See `Description=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Description=).  A free-form string describing the mount unit.  Defaults to the resource title.

##### `mnt_directorymode`
See `DirectoryMode=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#DirectoryMode=).  Directories of mount points (and any parent directories) are automatically created if needed using this mode.  The default is `undef` meaning this optional setting is omitted from the unit file, which results in a systemd default of `0755`.

##### `mnt_options`
See `Options=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#Options=).  Mount options to use when mounting.  Must match the [Systemd::Unitlist](#systemdunitlist-data-type) data type.  The default is `undef` meaning this optional setting is omitted from the unit file.

##### `mnt_requires`
See `Requires=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Requires=).  Configures requirement dependencies on other systemd units.  Must match the [Systemd::Unitlist](#systemdunitlist-data-type) data type.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd make this mount require some other unit, you likely want to do the same via Puppet's "require" meta-parameter.  It's your responsibility to ensure they agree.

##### `mnt_timeoutsec`
See `TimeoutSec=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#TimeoutSec=).  Configures the time to wait for the mount command to finish.  The default is `undef` meaning this optional setting is omitted from the unit file, which results in a systemd default of 90 seconds.

##### `mnt_type`
See `Type=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#Type=).  Takes a string for the filesystem type.  The default is `undef` meaning this optional setting is omitted from the unit file.

##### `mnt_where`
See `Where=` in [SYSTEMD.MOUNT(5)](https://www.freedesktop.org/software/systemd/man/systemd.mount.html#Where=).  Takes an absolute path of a directory of the mount point.  See also *namevar* above for an alternate way to specify the mount point.

##### `mnt_wantedby`
See `WantedBy=` in [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#WantedBy=).  The systemd target in which this mount is wanted.  This is only relevant when `enabled` is `true`.  Defaults to `multi-user.target`, though values such as `local-fs.target` and `remote-fs.target` may also be good choices.  Run `systemctl -l -t target` for a list of targets.  Must match the [Systemd::Unitlist](#systemdunitlist-data-type) data type.

Note that if it makes sense to have systemd make this mount be wanted by some other unit, you likely want to do the same via Puppet's *require* meta-parameter.  It's your responsibility to ensure they agree.


#### systemd::unit defined type

This defined type manages a systemd unit configuration file.

##### `namevar` (REQUIRED)
An arbitrary identifier for the unit file.  See [SYSTEMD.UNIT(5)](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) for valid naming requirements.  See *extends* also.

##### `ensure`
The [Systemd::Unit::Ensure](#systemdunitensure-data-type) data type specifying the state of unit file (`present` (default) or `absent`) or the state of the unit that file represents (`started` or `stopped`, both of which also imply `present`).  `running` may also be specified and will be treated identically to `started`.

##### `enable`
Instance is to be enabled at boot.  The default is `true`.  A value of `undef` indicates that the boot state is to be left unchanged.  This is the appropriate choice for units lacking an `[Install]` section.

##### `content`
Literal content for the unit file.  One and only one of *content* or *source* must be given.

##### `source`
URI of the unit file content.  One and only one of *content* or *source* must be given.

##### `restart_events`
[Event or list of events](#systemdeventlist-data-type) that should cause the unit to be restarted.  The default is `undef`.

##### `extends`
Name of an extant unit.  This is useful, for example, if you want to alter only some fraction of a vendor-provided unit.  Requires systemd >= 198.

When the `extends` parameter is used, *namevar* must have a `.conf` suffix to be recognized by systemd as a unit extension file.

##### `path`
Path to unit file sans the base name.  Defaults to `/etc/systemd/system` unless *extends* is set in which case the default becomes `/etc/systemd/system/${extends}.d`.  Any missing parent directories will be created, if necessary.


### Data types

#### Systemd::Eventlist data type

Matches:

* non-empty strings or arrays of them
* Puppet resource types or arrays of them


#### Systemd::Flexsize data type

Matches:

* positive integers
* positive integers followed immediately by one of: `%`, `K`, `M`, `G`, `T`, `P` or `E`


#### Systemd::Journald::Level data type

Matches:

* integers from `0` through `7`, inclusive
* one of: `emerg` (0), `alert`, `crit`, `err`, `warning`, `notice`, `info` or `debug` (7)


#### Systemd::Logind::Event data type

Matches:

* one of: `ignore`, `poweroff`, `reboot`, `halt`, `kexec`, `suspend`, `hibernate`, `hybrid-sleep` or `lock`


#### Systemd::Period data type

Matches:

* positive integers
* positive integers followed immediately by one of: `year`, `month`, `week`, `day`, `h` or `m`


#### Systemd::Rate data type

Matches:

* positive integers
* positive integers followed immediately by one of: `min`, `ms`, `us`, `s` or `h`


#### Systemd::Size data type

Matches:

* positive integers
* positive integers followed immediately by one of: `K`, `M`, `G`, `T`, `P` or `E`


#### Systemd::Unit::Ensure data type

Matches:

* one of: `absent`, `present`, `running`, `started` or `stopped`


#### Systemd::Unitlist data type

Matches:

* non-empty strings or arrays of them


### Facts

### Functions

#### systemd::escape function

Returns an escaped file system path for a mount point per systemd rules.

See [SYSTEMD-ESCAPE(1)](https://www.freedesktop.org/software/systemd/man/systemd-escape.html), specifically the `--path` option, for more details.

##### `path` (REQUIRED)
The mount point path that is to be escaped.

##### `suffix`
The unit-type suffix to be included in the returned value.  Defaults to `'mount'`.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
