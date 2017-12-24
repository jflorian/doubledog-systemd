# Synopsis:
#       Parameters for the systemd Puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class systemd::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            # This is a static service.
            $logind_services = 'systemd-logind'
            $logind_enable = undef
            $logind_ensure = undef

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
