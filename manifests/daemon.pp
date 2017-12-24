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
# Copyright 2014-2017 John Florian


class systemd::daemon () {

    exec { 'systemctl daemon-reload':
        refreshonly => true,
    }

}
