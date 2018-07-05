#
# == Class: systemd::journald
#
# Manages the systemd journald daemon on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2015-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class systemd::journald (
        String[1]                                   $service,
        Optional[Boolean]                           $compress,
        Optional[Boolean]                           $forward_to_console,
        Optional[Boolean]                           $forward_to_kmsg,
        Optional[Boolean]                           $forward_to_syslog,
        Optional[Boolean]                           $forward_to_wall,
        Optional[Variant[Integer[0], String[1]]]    $max_file_sec,
        Optional[Systemd::Journald::Level]          $max_level_console,
        Optional[Systemd::Journald::Level]          $max_level_kmsg,
        Optional[Systemd::Journald::Level]          $max_level_store,
        Optional[Systemd::Journald::Level]          $max_level_syslog,
        Optional[Systemd::Journald::Level]          $max_level_wall,
        Optional[Variant[Integer[0], String[1]]]    $max_retention_sec,
        Optional[Variant[Integer[0], String[1]]]    $rate_limit_burst,
        Optional[Variant[Integer[0], String[1]]]    $rate_limit_interval_sec,
        Optional[Variant[Integer[0], String[1]]]    $runtime_keep_free,
        Optional[Variant[Integer[0], String[1]]]    $runtime_max_file_size,
        Optional[Variant[Integer[0], String[1]]]    $runtime_max_files,
        Optional[Variant[Integer[0], String[1]]]    $runtime_max_use,
        Optional[Boolean]                           $seal,
        Optional[Enum['uid', 'none']]               $split_mode,
        Optional[Enum['volatile', 'persistent', 'auto', 'none']]  $storage,
        Optional[Variant[Integer[0], String[1]]]    $sync_interval_sec,
        Optional[Variant[Integer[0], String[1]]]    $system_keep_free,
        Optional[Variant[Integer[0], String[1]]]    $system_max_file_size,
        Optional[Variant[Integer[0], String[1]]]    $system_max_files,
        Optional[Variant[Integer[0], String[1]]]    $system_max_use,
        Optional[String[1]]                         $tty_path,
    ) {

    include '::systemd'

    file {
        default:
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'etc_t',
            before    => Service[$service],
            notify    => Service[$service],
            subscribe => Package[$::systemd::packages],
            ;
        '/etc/systemd/journald.conf':
            content => template('systemd/journald.conf.erb'),
            ;
    }

    service { $service:
        # This is a static service.
        ensure     => undef,
        enable     => undef,
        hasrestart => true,
        hasstatus  => true,
    }

}
