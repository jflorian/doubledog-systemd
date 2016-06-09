# modules/systemd/manifests/params.pp
#
# Synopsis:
#       Parameters for the systemd Puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2016 John Florian


class systemd::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $packages = 'systemd'

            # This is a static service.
            $journald_services = 'systemd-journald'
            $journald_enable = undef
            $journald_ensure = undef

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
