#
# == Class: systemd::daemon
#
# Manage the systemd daemon.
#
# Due to the nature of systemd being the init process (PID 1), there is very
# little to handle here.  This chiefly exists to serve as an event
# notification target so that the systemd daemon can reload its configuration
# when needed.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2014-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class systemd::daemon () {

    exec { 'systemctl daemon-reload':
        refreshonly => true,
    }

}
