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
# Copyright 2015-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class systemd::journald (
        String[1]                                   $service,
        Optional[Boolean]                           $compress,
        Optional[Boolean]                           $forward_to_console,
        Optional[Boolean]                           $forward_to_kmsg,
        Optional[Boolean]                           $forward_to_syslog,
        Optional[Boolean]                           $forward_to_wall,
        Optional[Systemd::Period]                   $max_file_sec,
        Optional[Systemd::Journald::Level]          $max_level_console,
        Optional[Systemd::Journald::Level]          $max_level_kmsg,
        Optional[Systemd::Journald::Level]          $max_level_store,
        Optional[Systemd::Journald::Level]          $max_level_syslog,
        Optional[Systemd::Journald::Level]          $max_level_wall,
        Optional[Systemd::Period]                   $max_retention_sec,
        Optional[Systemd::Rate]                     $rate_limit_burst,
        Optional[Systemd::Rate]                     $rate_limit_interval_sec,
        Optional[Systemd::Size]                     $runtime_keep_free,
        Optional[Systemd::Size]                     $runtime_max_file_size,
        Optional[Systemd::Size]                     $runtime_max_files,
        Optional[Systemd::Size]                     $runtime_max_use,
        Optional[Boolean]                           $seal,
        Optional[Enum['uid', 'none']]               $split_mode,
        Optional[Enum['volatile', 'persistent', 'auto', 'none']]  $storage,
        Optional[Systemd::Period]                   $sync_interval_sec,
        Optional[Systemd::Size]                     $system_keep_free,
        Optional[Systemd::Size]                     $system_max_file_size,
        Optional[Systemd::Size]                     $system_max_files,
        Optional[Systemd::Size]                     $system_max_use,
        Optional[String[1]]                         $tty_path,
    ) {

    include 'systemd'

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
            subscribe => Package[$systemd::packages],
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
