# modules/systemd/manifests/params.pp
#
# Synopsis:
#       Parameters for the systemd puppet module.


class systemd::params {

    case $::operatingsystem {

        'Fedora': {

            $packages = [
                'systemd',
            ]

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
