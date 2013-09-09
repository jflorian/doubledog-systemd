# modules/systemd/manifests/params.pp
#
# Synopsis:
#       Parameters for the systemd puppet module.


class systemd::params {

    case $::operatingsystem {
        Fedora: {

            $packages = [
                'systemd',
            ]

        }

        default: {
            fail ("The systemd module is not yet supported on ${operatingsystem}.")
        }

    }

}
