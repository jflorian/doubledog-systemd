# modules/systemd/manifests/init.pp
#
# Synopsis:
#       Configures a host for running systemd.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       NONE


class systemd {

    include 'systemd::daemon'
    include 'systemd::params'

    package { $systemd::params::packages:
        ensure  => installed,
    }

    File {
        owner       => 'root',
        group       => 'root',
        mode        => '0644',
        seluser     => 'system_u',
        selrole     => 'object_r',
        seltype     => 'etc_t',
        subscribe   => Package[$systemd::params::packages],
    }

    if  $operatingsystem == 'Fedora' and
        $operatingsystemrelease == 'Rawhide' or
        $operatingsystemrelease >= 18
    {

        file { '/etc/systemd/journald.conf':
            source  => [
                'puppet:///private-host/systemd/journald.conf',
                'puppet:///private-domain/systemd/journald.conf',
                'puppet:///modules/systemd/journald.conf',
            ],
        }

    }

}
