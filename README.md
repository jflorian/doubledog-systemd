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


### Classes

#### systemd class

This class manages the systemd package.

##### `packages`
An array of package names needed for the systemd installation.  The default should be correct for supported platforms.


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
* `max_file_sec`
* `max_level_console`
* `max_level_kmsg`
* `max_level_store`
* `max_level_syslog`
* `max_level_wall`
* `max_retention_sec`
* `rate_limit_burst`
* `rate_limit_interval_sec`
* `runtime_keep_free`
* `runtime_max_file_size`
* `runtime_max_files`
* `runtime_max_use`
* `seal`
* `split_mode`
* `storage`
* `sync_interval_sec`
* `system_keep_free`
* `system_max_file_size`
* `system_max_files`
* `system_max_use`
* `tty_path`


#### systemd::logind class

This class manages the systemd logind daemon.

##### `service`
The service name of the systemd logind daemon.

##### other parameters

For the following parameters, see `man logind.conf` for their use.  The parameter names have been normalized for Puppet so that `CamelCase` becomes `camel_case`.

Passing `undef` (the default value) causes the compiled defaults for the logind service to be used.  In other words, the setting will not be present in the configuration file.

* `handle_hibernate_key`
* `handle_lid_switch`
* `handle_lid_switch_docked`
* `handle_power_key`
* `handle_suspend_key`
* `hibernate_key_ignore_inhibited`
* `holdoff_timeout_sec`
* `idle_action`
* `idle_action_sec`
* `inhibit_delay_max_sec`
* `kill_exclude_users`
* `kill_only_users`
* `kill_user_processes`
* `lid_switch_ignore_inhibited`
* `nauto_vts`
* `power_key_ignore_inhibited`
* `remove_ipc`
* `reserve_vt`
* `runtime_directory_size`
* `suspend_key_ignore_inhibited`


### Defined types

#### systemd::mount defined type

This defined type manages a systemd mount unit configuration file.

Generally, it's advisable to simply use Puppet's `mount` resource type instead of this.  However, in some cases this definition has distinct advantages such as when there are inter-dependencies between a mount and other units.

Any option below whose name begins with `mnt_` is passed directly to the mount unit as a systemd parameter of the exact same name, sans the prefix.  This helps distinguish these from Puppet parameters (especially meta-) that share the same name.

##### `namevar` (REQUIRED)
An arbitrary identifier for the mount instance unless the `mnt_where` parameter is not set in which case this must provide the value normally set with the `mnt_where` parameter.

##### `mnt_what` (REQUIRED)
See `What=` in systemd.mount(5).  Takes an absolute path of a device node, file or other resource to mount.

##### `ensure`
Instance is to be `present` (default) or `absent`.

##### `enable`
Instance is to be enabled at boot.  The default is `undef` which means the mount won't be started as part of a target (i.e., `mnt_wantedby`).  Typically, this is what you'd want because it's generally better to use `mnt_before` instead so that this mount is ready by the time a target is reached.

##### `mnt_after`
See `After=` in systemd.unit(5).  Configures ordering dependencies between systemd units.  This may be passed as either as a single string or an array of such.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd start this mount after some other unit, you likely want to do the same via Puppet's sequencing meta-parameters.  It's your responsibility to ensure they agree.

##### `mnt_before`
See `Before=` in systemd.unit(5).  Configures ordering dependencies between systemd units.  This may be passed as either as a single string or an array of such.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd start this mount before some other unit, you likely want to do the same via Puppet's sequencing meta-parameters.  It's your responsibility to ensure they agree.

##### `mnt_description`
See `Description=` in systemd.unit(5).  A free-form string describing the mount unit.  Defaults to the resource title.

##### `mnt_directorymode`
See `DirectoryMode=` in systemd.mount(5).  Directories of mount points (and any parent directories) are automatically created if needed using this mode.  The default is `undef` meaning this optional setting is omitted from the unit file, which results in a systemd default of `0755`.

##### `mnt_options`
See `Options=` in systemd.mount(5).  Mount options to use when mounting.  This may be passed as either as a single string or an array of such.  The default is `undef` meaning this optional setting is omitted from the unit file.

##### `mnt_requires`
See `Requires=` in systemd.unit(5).  Configures requirement dependencies on other systemd units.  This may be passed as either as a single string or an array of such.  The default is `undef` meaning this setting is omitted from the unit file.

Note that if it makes sense to have systemd make this mount require some other unit, you likely want to do the same via Puppet's "require" meta-parameter.  It's your responsibility to ensure they agree.

##### `mnt_timeoutsec`
See `TimeoutSec=` in systemd.mount(5).  Configures the time to wait for the mount command to finish.  The default is `undef` meaning this optional setting is omitted from the unit file, which results in a systemd default of 90 seconds.

##### `mnt_type`
See `Type=` in systemd.mount(5).  Takes a string for the filesystem type.  The default is `undef` meaning this optional setting is omitted from the unit file.

##### `mnt_where`
See `Where=` in systemd.mount(5).  Takes an absolute path of a directory of the mount point.  See also `namevar` above for an alternate way to specify the mount point.

##### `mnt_wantedby`
See `WantedBy=` in systemd.unit(5).  The systemd target in which this mount is wanted.  This is only relevant when `enabled` is `true`.  Defaults to `multi-user.target`, though values such as `local-fs.target` and `remote-fs.target` may also be good choices.  Run `systemctl -l -t target` for a list of targets.  This may be passed as either as a single string or an array of such.

Note that if it makes sense to have systemd make this mount be wanted by some other unit, you likely want to do the same via Puppet's `require` meta-parameter.  It's your responsibility to ensure they agree.


#### systemd::unit defined type

This defined type manages a systemd unit configuration file.

##### `namevar` (REQUIRED)
An arbitrary identifier for the unit file.  See systemd.unit(5) for valid naming requirements.  See `extends` also.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.

##### `enable`
Instance is to be enabled at boot.  The default is `true`.  A value of `undef` indicates that the boot state is to be left unchanged.  This is the appropriate choice for units lacking an `[Install]` section.

##### `content`
Literal content for the unit file.  One and only one of `content` or `source` must be given.

##### `source`
URI of the unit file content.  One and only one of `content` or `source` must be given.

##### `restart_events`
Event or list of events that should cause the unit to be restarted.  The default is `undef`.

##### `extends`
Name of an extant unit.  This is useful, for example, if you want to alter only some fraction of a vendor-provided unit.  Requires systemd >= 198.

When the `extends` parameter is used, `namevar` must have a `.conf` suffix to be recognized by systemd as a unit extension file.

##### `path`
Path to unit file sans the base name.  Defaults to `/etc/systemd/system` unless `extends` is set in which case the default becomes `/etc/systemd/system/${extends}.d`.  Any missing parent directories will be created, if necessary.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

This should be compatible with Puppet 3.x and is being used with Puppet 4.x as
well.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
