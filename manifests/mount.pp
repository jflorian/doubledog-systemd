# modules/systemd/manifests/mount.pp
#
# == Define: systemd::mount
#
# Manage a systemd mount unit configuration file.
#
# Generally it's advisable to simply use Puppet's "mount" resource type
# instead of this.  However, in some cases this definition has distinct
# advantages such as when complex dependencies exist.
#
# === Parameters
#
# Any option below whose name begins with "mnt_" is passed directly to the
# mount unit as a systemd parameter of the exact same name, sans the prefix.
# This helps distinguish these from Puppet parameters (especially meta-) that
# share the same name.
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the mount instance unless the "mnt_where"
#   parameter is not set in which case this must provide the value normally
#   set with the "mnt_where" parameter.
#
# [*mnt_what*]
#   See "What=" in systemd.mount(5).  Takes an absolute path of a device node,
#   file or other resource to mount.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*enable*]
#   Instance is to be enabled at boot.  The default is undef which means the
#   mount won't be started as part of a target (i.e., "mnt_wantedby").
#   Typically this is what you'd want because it's generally better to use
#   "mnt_before" instead so that this mount is ready by the time a target is
#   reached.
#
# [*mnt_after*]
#   See "After=" in systemd.unit(5).  Configures ordering dependencies between
#   systemd units.  This may be passed as either as a single string or an
#   array of such.  The default is undef meaning this setting is omitted from
#   the unit file.
#
#   Note that if it makes sense to have systemd start this mount after some
#   other unit, you likely want to do the same via Puppet's sequencing
#   meta-parameters.  It's your responsibility to ensure they agree.
#
# [*mnt_before*]
#   See "Before=" in systemd.unit(5).  Configures ordering dependencies
#   between systemd units.  This may be passed as either as a single string or
#   an array of such.  The default is undef meaning this setting is
#   omitted from the unit file.
#
#   Note that if it makes sense to have systemd start this mount before some
#   other unit, you likely want to do the same via Puppet's sequencing
#   meta-parameters.  It's your responsibility to ensure they agree.
#
# [*mnt_description*]
#   See "Description=" in systemd.unit(5).  A free-form string describing the
#   mount unit.  Defaults to the resource title.
#
# [*mnt_directorymode*]
#   See "DirectoryMode=" in systemd.mount(5).  Directories of mount points
#   (and any parent directories) are automatically created if needed using
#   this mode.  The default is undef meaning this optional setting is
#   omitted from the unit file, which results in a systemd default of 0755.
#
# [*mnt_options*]
#   See "Options=" in systemd.mount(5).  Mount options to use when mounting.
#   This may be passed as either as a single string or an array of such.  The
#   default is undef meaning this optional setting is omitted from the unit
#   file.
#
# [*mnt_requires*]
#   See "Requires=" in systemd.unit(5).  Configures requirement dependencies
#   on other systemd units.  This may be passed as either as a single string
#   or an array of such.  The default is undef meaning this setting is
#   omitted from the unit file.
#
#   Note that if it makes sense to have systemd make this mount require some
#   other unit, you likely want to do the same via Puppet's "require"
#   meta-parameter.  It's your responsibility to ensure they agree.
#
# [*mnt_timeoutsec*]
#   See "TimeoutSec=" in systemd.mount(5).  Configures the time to wait for
#   the mount command to finish.  The default is undef meaning this optional
#   setting is omitted from the unit file, which results in a systemd default
#   of 90 seconds.
#
# [*mnt_type*]
#   See "Type=" in systemd.mount(5).  Takes a string for the filesystem type.
#   The default is undef meaning this optional setting is omitted from the
#   unit file.
#
# [*mnt_where*]
#   See "Where=" in systemd.mount(5).  Takes an absolute path of a directory
#   of the mount point.  See also "namevar" above for an alternate way to
#   specify the mount point.
#
# [*mnt_wantedby*]
#   See "WantedBy=" in systemd.unit(5).  The systemd target in which this
#   mount is wanted.  This is only relevant when "enabled" is true.  Defaults
#   to 'multi-user.target', though values such as 'local-fs.target' and
#   'remote-fs.target' may also be good choices.  Run "systemctl -l -t target"
#   for a list of targets.  This may be passed as either as a single string or
#   an array of such.
#
#   Note that if it makes sense to have systemd make this mount be wanted by
#   some other unit, you likely want to do the same via Puppet's "require"
#   meta-parameter.  It's your responsibility to ensure they agree.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016 John Florian


define systemd::mount (
        $mnt_what,
        $ensure='present',
        $enable=undef,
        $mnt_after=undef,
        $mnt_before=undef,
        $mnt_description=$title,
        $mnt_directorymode=undef,
        $mnt_options=undef,
        $mnt_requires=undef,
        $mnt_timeoutsec=undef,
        $mnt_type=undef,
        $mnt_wantedby='multi-user.target',
        $mnt_where=$title,
    ) {

    # It might be nice to also validate $mnt_what, but it could be in NFS form
    # of host:export or other such value that validate_absolute_path() cannot
    # handle.
    validate_absolute_path($mnt_where)

    $sterile_name = systemd_escaped_mount_path($mnt_where)

    ::systemd::unit { "${sterile_name}":
        ensure  => $ensure,
        enable  => $enable,
        content => template('systemd/mount.erb'),
    }
}
