# == Define: systemd::unit
#
# Manages a systemd unit configuration file.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2013-2018 John Florian


define systemd::unit (
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        $enable=true,
        $running=true,
        $content=undef,
        $source=undef,
        $restart_events=undef,
        $path=undef,
        $extends=undef,
    ) {

    include '::systemd::daemon'

    if $enable != true and $enable != false and $enable != undef {
        fail('$enable must be "true", "false" or undef')
    }

    validate_bool($running)

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

    if $ensure == 'present' or $ensure == true {

        if $enable == true {
            exec { "systemctl enable ${target}":
                require => Class['::systemd::daemon'],
                unless  => "systemctl is-enabled ${target}",
            }
        } elsif $enable == false {
            exec { "systemctl disable ${target}":
                require => Class['::systemd::daemon'],
                onlyif  => "systemctl is-enabled ${target}",
            }
        }

        exec { "systemctl start ${target}":
            require => Class['::systemd::daemon'],
            unless  => "systemctl is-active ${target}",
        }

        exec { "systemctl restart ${target}":
            refreshonly => true,
            require     => Class['::systemd::daemon'],
            subscribe   => delete_undef_values([
                File[$fqfn],
                $restart_events,
            ]),
        }

    } else {

        if $extends == undef {
            exec { "systemctl disable ${target}":
                before => File[$fqfn],
                onlyif => "test -e '${fqfn}'",
            }

            exec { "systemctl stop ${target}":
                before => File[$fqfn],
                onlyif => "test -e '${fqfn}'",
            }
        }

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
        mode    => '0644',
        notify  => Class['::systemd::daemon'],
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'systemd_unit_file_t',
        content => $content,
        source  => $source,
    }

}
