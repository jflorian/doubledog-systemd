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
# Copyright 2013-2017 John Florian


class systemd (
        Array[String[1], 1]         $packages,
    ) {

    include '::systemd::daemon'

    package { $packages:
        ensure => installed,
        notify => Class['::systemd::daemon'],
    }

}
