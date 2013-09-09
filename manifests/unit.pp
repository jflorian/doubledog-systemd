# modules/systemd/manifests/unit.pp
#
# Synopsis:
#       Install a systemd unit.
#
# Parameters:
#       Name__________  Default_______  Description___________________________
#
#       name                            name of the systemd unit
#       ensure          present         unit is to be present/absent
#       enable          true            unit is to be enabled/disabled at boot
#       running         true            unit is to be running/stopped now
#       content*        undef           path to template content
#       source*         undef           URL to source content
#
#       * content/source are mutually exclusive and one must be set.  If both
#       are set, only content will be honored; source will be ignored.
#
# Requires:
#       Class['systemd']
#
# Example usage:
#
#       include systemd
#
#       systemd::unit { 'vncserver.service':
#           content => template('vnc/vncserver.service'),
#       }


define systemd::unit ($ensure='present', $enable=true, $running=true,
                      $content=undef, $source=undef) {

    if $ensure == 'present' {

        exec { "systemctl enable $name":
            require     => Exec["daemon-reload for unit $name"],
            unless      => "systemctl is-enabled $name",
        }

        exec { "systemctl start $name":
            require     => Exec["daemon-reload for unit $name"],
            unless      => "systemctl is-active $name",
        }

    } elsif $ensure == 'absent' {

        exec { "systemctl disable $name":
            before => File["/etc/systemd/system/${name}"],
            onlyif => "test -e \"/etc/systemd/system/${name}\"",
        }

        exec { "systemctl stop $name":
            before => File["/etc/systemd/system/${name}"],
            onlyif => "test -e \"/etc/systemd/system/${name}\"",
        }

    } else {
        fail('$ensure must be "present" or "absent"')
    }

    if $enable != true and $enable != false {
        fail('$enable must be "true" or "false"')
    }

    if $running != true and $running != false {
        fail('$running must be "true" or "false"')
    }

    if $content == undef and $source == undef {
        fail('either $content or $source must be set')
    }

    if $content != undef {

        file { "/etc/systemd/system/${name}":
            content     => $content,
            ensure      => $ensure,
            group       => 'root',
            mode        => '0640',
            notify      => Exec["daemon-reload for unit $name"],
            owner       => 'root',
            seluser     => 'system_u',
            selrole     => 'object_r',
            seltype     => 'systemd_unit_file_t',
        }

    } else {

        file { "/etc/systemd/system/${name}":
            ensure      => $ensure,
            group       => 'root',
            mode        => '0640',
            notify      => Exec["daemon-reload for unit $name"],
            owner       => 'root',
            seluser     => 'system_u',
            selrole     => 'object_r',
            seltype     => 'systemd_unit_file_t',
            source      => $source,
        }

    }

    exec { "daemon-reload for unit $name":
        command         => 'systemctl daemon-reload',
        refreshonly     => true,
    }

}
