# == Class: systemd::logind
#
# Manages the systemd logind daemon on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class systemd::logind (
        $handle_hibernate_key,
        $handle_lid_switch,
        $handle_lid_switch_docked,
        $handle_power_key,
        $handle_suspend_key,
        $hibernate_key_ignore_inhibited,
        $holdoff_timeout_sec,
        $idle_action,
        $idle_action_sec,
        $inhibit_delay_max_sec,
        $kill_exclude_users,
        $kill_only_users,
        $kill_user_processes,
        $lid_switch_ignore_inhibited,
        $nauto_vts,
        $power_key_ignore_inhibited,
        $remove_ipc,
        $reserve_vt,
        $runtime_directory_size,
        String[1]   $service,
        $suspend_key_ignore_inhibited,
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
        '/etc/systemd/logind.conf':
            content => template('systemd/logind.conf.erb'),
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
