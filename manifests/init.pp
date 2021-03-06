#
# == Class: systemd
#
# Manages systemd on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2013-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class systemd (
        Hash[String[1], Hash]       $mounts,
        Array[String[1], 1]         $packages,
        Hash[String[1], Hash]       $units,
    ) {

    include 'systemd::daemon'

    package { $packages:
        ensure => installed,
        notify => Class['systemd::daemon'],
    }

    create_resources(systemd::mount, $mounts)

    create_resources(systemd::unit, $units)

}
