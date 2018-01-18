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
# Copyright 2015-2018 John Florian


class systemd::logind (
        String[1]                                   $service,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $handle_hibernate_key,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $handle_lid_switch,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $handle_lid_switch_docked,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $handle_power_key,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $handle_suspend_key,
        Optional[Enum['ignore', 'poweroff', 'reboot', 'halt', 'kexec', 'suspend', 'hibernate', 'hybrid-sleep', 'lock']]   $idle_action,
        Optional[Boolean]                           $hibernate_key_ignore_inhibited,
        Optional[Integer[0]]                        $holdoff_timeout_sec,
        Optional[Integer[0]]                        $idle_action_sec,
        Optional[Integer[0]]                        $inhibit_delay_max_sec,
        Optional[Array[String]]                     $kill_exclude_users,
        Optional[Array[String]]                     $kill_only_users,
        Optional[Boolean]                           $kill_user_processes,
        Optional[Boolean]                           $lid_switch_ignore_inhibited,
        Optional[Integer[0]]                        $n_auto_vts,
        Optional[Boolean]                           $power_key_ignore_inhibited,
        Optional[Boolean]                           $remove_ipc,
        Optional[Integer[0]]                        $reserve_vt,
        Optional[Variant[Integer[0], String[1]]]    $runtime_directory_size,
        Optional[Boolean]                           $suspend_key_ignore_inhibited,
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
