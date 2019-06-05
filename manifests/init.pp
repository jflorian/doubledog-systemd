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
        Array[String[1], 1]         $packages,
    ) {

    include 'systemd::daemon'

    package { $packages:
        ensure => installed,
        notify => Class['systemd::daemon'],
    }

}
