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
# Copyright 2016-2018 John Florian


define systemd::mount (
        String[1]                                       $mnt_what,
        Variant[Boolean, Enum['present', 'absent']]     $ensure='present',
        Optional[Boolean]                               $enable=true,
        Optional[Variant[String[1], Array[String[1]]]]  $mnt_after=undef,
        Optional[Variant[String[1], Array[String[1]]]]  $mnt_before=undef,
        String[1]                                       $mnt_description=$title,
        Optional[String[3]]                             $mnt_directorymode=undef,
        Optional[Variant[String[1], Array[String[1]]]]  $mnt_options=undef,
        Optional[Variant[String[1], Array[String[1]]]]  $mnt_requires=undef,
        Optional[Integer[0]]                            $mnt_timeoutsec=undef,
        Optional[String[1]]                             $mnt_type=undef,
        Variant[String[1], Array[String[1]]]            $mnt_wantedby='multi-user.target',
        Optional[String[1]]                             $mnt_where=$title,
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
