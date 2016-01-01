# modules/systemd/manifests/init.pp
#
# == Class: systemd
#
# Manages systemd on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2013-2016 John Florian


class systemd (
    ) inherits ::systemd::params {

    include '::systemd::daemon'

    package { $::systemd::params::packages:
        ensure => installed,
        notify => Class['::systemd::daemon'],
    }

}
