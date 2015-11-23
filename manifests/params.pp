# modules/systemd/manifests/params.pp
#
# Synopsis:
#       Parameters for the systemd puppet module.


class systemd::params {

    case $::operatingsystem {

        'CentOS': {

            $packages = 'systemd'
            $journald_services = 'systemd-journald'
            $journald_enable = false
            $journald_ensure = 'running'

        }

        'Fedora': {

            $packages = 'systemd'
            $journald_services = 'systemd-journald'

            if $::operatingsystemrelease >= '23' {
                # This is a static service on Fedora 23 and later.
                $journald_enable = undef
                $journald_ensure = undef
            } else {
                $journald_enable = true
                $journald_ensure = 'running'
            }

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
