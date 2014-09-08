# modules/systemd/manifests/unit.pp
#
# == Define: systemd::unit
#
# Installs a systemd unit configuration file.
#
# === Parameters
#
# [*namevar*]
#   An arbitrary identifier for the unit file.
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*enable*]
#   Instance is to be enabled at boot.  The default is true.  A value of undef
#   indicates that the boot state is to be left unchanged.  This is the
#   appropriate choice for units lacking an [Install] section.
#
# [*running*]
#   Instance is to be running/stopped now.  The default is 'true'.
#
# [*content*]
#   Literal content for the unit file.  One and only one of "content"
#   or "source" must be given.
#
# [*source*]
#   URI of the unit file content.  One and only one of "content" or
#   "source" must be given.
#
# [*restart_events*]
#   Event or list of events that should cause the unit to be restarted.  The
#   default is 'undef'.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>


define systemd::unit (
        $ensure='present',
        $enable=true,
        $running=true,
        $content=undef,
        $source=undef,
        $restart_events=undef,
    ) {

    if $enable != true and $enable != false {
        fail('$enable must be "true" or "false"')
    }

    if $running != true and $running != false {
        fail('$running must be "true" or "false"')
    }

    if $content == undef and $source == undef {
        fail('either $content or $source must be set')
    }

    if $ensure == 'present' {

        if $enable == true {
            exec { "systemctl enable ${name}":
                require => Class['systemd::daemon'],
                unless  => "systemctl is-enabled ${name}",
            }
        } elsif $enable == false {
            exec { "systemctl disable ${name}":
                require => Class['systemd::daemon'],
                onlyif  => "systemctl is-enabled ${name}",
            }
        }

        exec { "systemctl start ${name}":
            require => Class['systemd::daemon'],
            unless  => "systemctl is-active ${name}",
        }

        if $restart_events != undef {
            exec { "systemctl restart ${name}":
                refreshonly => true,
                subscribe   => $restart_events,
            }
        }

    } elsif $ensure == 'absent' {

        exec { "systemctl disable ${name}":
            before => File["/etc/systemd/system/${name}"],
            onlyif => "test -e \"/etc/systemd/system/${name}\"",
        }

        exec { "systemctl stop ${name}":
            before => File["/etc/systemd/system/${name}"],
            onlyif => "test -e \"/etc/systemd/system/${name}\"",
        }

    } else {
        fail('$ensure must be "present" or "absent"')
    }


    file { "/etc/systemd/system/${name}":
        ensure  => $ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        notify  => Class['systemd::daemon'],
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'systemd_unit_file_t',
        content => $content,
        source  => $source,
    }

}
