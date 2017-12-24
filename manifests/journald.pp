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
# Copyright 2015-2017 John Florian


class systemd::journald (
        $compress,
        $forward_to_console,
        $forward_to_kmsg,
        $forward_to_syslog,
        $forward_to_wall,
        $max_file_sec,
        $max_level_console,
        $max_level_kmsg,
        $max_level_store,
        $max_level_syslog,
        $max_level_wall,
        $max_retention_sec,
        $rate_limit_burst,
        $rate_limit_interval_sec,
        $runtime_keep_free,
        $runtime_max_file_size,
        $runtime_max_files,
        $runtime_max_use,
        $seal,
        String[1]   $service,
        $split_mode,
        $storage,
        $sync_interval_sec,
        $system_keep_free,
        $system_max_file_size,
        $system_max_files,
        $system_max_use,
        $tty_path,
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
