#
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
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2013-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define systemd::unit (
        Systemd::Unit::Ensure           $ensure='present',
        Optional[Boolean]               $enable=true,
        Optional[String]                $content=undef,
        Optional[String]                $source=undef,
        Optional[Systemd::Eventlist]    $restart_events=undef,
        Optional[String[1]]             $path=undef,
        Optional[String[1]]             $extends=undef,
    ) {

    include 'systemd::daemon'


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

    if $ensure == 'absent' {

        $file_ensure = 'absent'

        if $extends == undef {
            exec { "systemctl disable '${target}'":
                before => File[$fqfn],
                onlyif => "test -e '${fqfn}'",
            }

            exec { "systemctl stop '${target}'":
                before => File[$fqfn],
                onlyif => "test -e '${fqfn}'",
            }
        }

    } else {

        $file_ensure = 'present'

        if $enable == true {
            exec {
                default:
                    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
                    require => Class['systemd::daemon'],
                ;

                "systemctl enable '${target}'":
                    unless => "systemctl is-enabled '${target}'",
                ;

                "systemctl reenable '${target}'":
                    refreshonly => true,
                    subscribe   => Exec["systemctl restart '${target}'"],
                ;
            }

        } elsif $enable == false {
            exec { "systemctl disable '${target}'":
                require => Class['systemd::daemon'],
                onlyif  => "systemctl is-enabled '${target}'",
            }
        }

        exec {
            default:
                require => Class['systemd::daemon'],
            ;

            "systemctl start '${target}'":
                unless  => "systemctl is-active '${target}'",
            ;

            "systemctl restart '${target}'":
                refreshonly => true,
                subscribe   => delete_undef_values([
                    File[$fqfn],
                    $restart_events,
                ]),
            ;
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
        ensure  => $file_ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Class['systemd::daemon'],
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'systemd_unit_file_t',
        content => $content,
        source  => $source,
    }

}
