# modules/systemd/manifests/params.pp
#
# Synopsis:
#       Parameters for the systemd puppet module.


class systemd::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $packages = 'systemd'
            $journald_services = 'systemd-journald'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
