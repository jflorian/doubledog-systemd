# == Define: systemd::mount
#
# Manage a systemd mount unit configuration file.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016-2017 John Florian


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
