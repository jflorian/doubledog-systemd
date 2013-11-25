# modules/systemd/manifests/mount.pp
#
# == Define: systemd::mount
#
# Installs a systemd mount unit configuration file.
#
# === Parameters
#
# Yes, the mnt_ prefixing is fugly, but it helps distinguish these from puppet
# parameters (especially meta-) that share the same name.  Parametes having
# this prefix are specifically for the mount unit file content alone.
#
# [*namevar*]
#   An arbitrary identifier for the mount instance unless the "mnt_where"
#   parameter is not set in which case this must provide the value normally
#   set with the "mnt_where" parameter.
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*enable*]
#   Instance is to be enabled at boot.  The default is true.
#
# [*mnt_description*]
#   See "Description=" in systemd.unit(5).  A free-form string describing the
#   mount unit.
#
# [*mnt_requires*]
#   See "Requires=" in systemd.unit(5).  Configures requirement dependencies
#   on other systemd units.  The default is undef meaning this setting is
#   omitted from the unit file.
#
# [*mnt_before*]
#   See "Before=" in systemd.unit(5).  Configures ordering dependencies
#   between systemd units.  The default is undef meaning this setting is
#   omitted from the unit file.
#
# [*mnt_after*]
#   See "After=" in systemd.unit(5).  Configures ordering dependencies between
#   systemd units.  The default is undef meaning this setting is omitted from
#   the unit file.
#
# [*mnt_what*]
#   See "What=" in systemd.mount(5).  Takes an absolute path of a device node,
#   file or other resource to mount.
#
# [*mnt_where*]
#   See "Where=" in systemd.mount(5).  Takes an absolute path of a directory
#   of the mount point.  See also "namevar" above for an alternate way to
#   specify the mount point.
#
# [*mnt_type*]
#   See "Type=" in systemd.mount(5).  Takes a string for the filesystem type.
#   The default is undef meaning this optional setting is omitted from the
#   unit file.
#
# [*mnt_options*]
#   See "Options=" in systemd.mount(5).  Mount options to use when mounting.
#   The default is undef meaning this optional setting is omitted from the
#   unit file.
#
# [*mnt_dir_mode*]
#   See "DirectoryMode=" in systemd.mount(5).  Directories of mount points
#   (and any parent directories) are automatically created if needed using
#   this mode.  The default is undef meaning this optional setting is
#   omitted from the unit file, which results in a systemd default of 0755.
#
# [*mnt_timeout_sec*]
#   See "TimeoutSec=" in systemd.mount(5).  Configures the time to wait for
#   the mount command to finish.  The default is undef meaning this optional
#   setting is omitted from the unit file, which results in a systemd default
#   of 90 seconds.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>


define systemd::mount (
        $ensure='present',
        $enable=true,
        $mnt_description,
        $mnt_requires=undef,
        $mnt_before=undef,
        $mnt_after=undef,
        $mnt_what,
        $mnt_where=undef,
        $mnt_type=undef,
        $mnt_options=undef,
        $mnt_dir_mode=undef,
        $mnt_timeout_sec=undef,
    ) {

    $real_name = $mnt_where ? {
        undef   => $name,
        default => $mnt_where,
    }

    # This roughly mimics systemd path name encoding rules.  It notably fails
    # for unprintable characters but is believed to otherwise be correct.
    # Search for "file system name space" or "escape the path" in
    # systemd.unit(5) for the exact rules.
    $sterile_name = $real_name ? {
        '/'     => '-',
        default => regsubst(regsubst($real_name, '^/|/$', ''), '/', '-', 'G')
    }

    systemd::unit { "${sterile_name}.mount":
        ensure  => $ensure,
        enable  => $enable,
        content => template('systemd/mount.erb'),
    }
}
