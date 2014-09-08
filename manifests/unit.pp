# modules/systemd/manifests/unit.pp
#
# == Define: systemd::unit
#
# Installs a systemd unit configuration file.
#
# === Parameters
#
# [*namevar*]
#   An arbitrary identifier for the unit file.  See systemd.unit(5) for valid
#   naming requirements.  See "extends" also.
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
# [*extends*]
#   Name of an extant unit.  This is useful, for example, if you want to alter
#   only some fraction of a vendor-provided unit.  Requires systemd >= 198.
#
#   When the "extends" parameter is used, "namevar" must have a '.conf'
#   suffix to be recognized by systemd as a unit extension file.
#
# [*path*]
#   Path to unit file sans the base name.  Defaults to '/etc/systemd/system'
#   unless "extends" is set in which case the default becomes
#   "/etc/systemd/system/${extends}.d".  Any missing parent directories will
#   be created, if necessary.
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
        $path=undef,
        $extends=undef,
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

    if $extends == undef {
        $target = $name
        $use_path = $path ? {
            undef   => '/etc/systemd/system',
            default => $path,
        }
    } else {
        $target = $extends
        $use_path = $path ? {
            undef   => "/etc/systemd/system/${extends}.d",
            default => $path,
        }
    }

    $fqfn = "${use_path}/${name}"

    if $ensure == 'present' {

        if $enable == true {
            exec { "systemctl enable ${target}":
                require => Class['systemd::daemon'],
                unless  => "systemctl is-enabled ${target}",
            }
        } elsif $enable == false {
            exec { "systemctl disable ${target}":
                require => Class['systemd::daemon'],
                onlyif  => "systemctl is-enabled ${target}",
            }
        }

        exec { "systemctl start ${target}":
            require => Class['systemd::daemon'],
            unless  => "systemctl is-active ${target}",
        }

        if $restart_events != undef {
            exec { "systemctl restart ${target}":
                refreshonly => true,
                subscribe   => $restart_events,
            }
        }

    } elsif $ensure == 'absent' {

        exec { "systemctl disable ${target}":
            before => File[$fqfn],
            onlyif => "test -e '${fqfn}'",
        }

        exec { "systemctl stop ${target}":
            before => File[$fqfn],
            onlyif => "test -e '${fqfn}'",
        }

    } else {
        fail('$ensure must be "present" or "absent"')
    }

    # NB: Don't collapse command into namevar!  namevar must retain inclusion
    # of $name to permit multiple systemd::unit instances per catalog.
    exec { "make unit path for ${name}":
        command => "mkdir -p '${use_path}'",
        unless  => "test -d '${use_path}'",
        before  => File[$fqfn],
    }

    file { $fqfn:
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
