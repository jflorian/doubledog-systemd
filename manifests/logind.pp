# modules/systemd/manifests/logind.pp
#
# == Class: systemd::logind
#
# Manages the systemd logind daemon on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# See "man logind.conf" for details on these settings.  Using the undef or the
# default values provided by this class will match the compiled defaults for
# the logind service.  In other words, the setting will not be specified in
# the configuration file.
#
# [*handle_hibernate_key*]
# [*handle_lid_switch*]
# [*handle_lid_switch_docked*]
# [*handle_power_key*]
# [*handle_suspend_key*]
# [*hibernate_key_ignore_inhibited*]
# [*holdoff_timeout_sec*]
# [*idle_action*]
# [*idle_action_sec*]
# [*inhibit_delay_max_sec*]
# [*kill_exclude_users*]
# [*kill_only_users*]
# [*kill_user_processes*]
# [*lid_switch_ignore_inhibited*]
# [*nauto_vts*]
# [*power_key_ignore_inhibited*]
# [*remove_ipc*]
# [*reserve_vt*]
# [*runtime_directory_size*]
# [*suspend_key_ignore_inhibited*]
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class systemd::logind (
        $enable=$::systemd::params::logind_enable,
        $ensure=$::systemd::params::logind_ensure,
        $handle_hibernate_key=undef,
        $handle_lid_switch=undef,
        $handle_lid_switch_docked=undef,
        $handle_power_key=undef,
        $handle_suspend_key=undef,
        $hibernate_key_ignore_inhibited=undef,
        $holdoff_timeout_sec=undef,
        $idle_action=undef,
        $idle_action_sec=undef,
        $inhibit_delay_max_sec=undef,
        $kill_exclude_users=undef,
        $kill_only_users=undef,
        $kill_user_processes=undef,
        $lid_switch_ignore_inhibited=undef,
        $nauto_vts=undef,
        $power_key_ignore_inhibited=undef,
        $remove_ipc=undef,
        $reserve_vt=undef,
        $runtime_directory_size=undef,
        $suspend_key_ignore_inhibited=undef,
    ) inherits ::systemd::params {

    include '::systemd'

    file {
        default:
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'etc_t',
            before    => Service[$::systemd::params::logind_services],
            notify    => Service[$::systemd::params::logind_services],
            subscribe => Package[$::systemd::params::packages],
            ;
        '/etc/systemd/logind.conf':
            content => template('systemd/logind.conf.erb'),
            ;
    }

    service { $::systemd::params::logind_services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }


}
