# modules/systemd/manifests/journald.pp
#
# == Class: systemd::journald
#
# Manages the systemd journald daemon on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*content*]
#   Literal content for the journald.conf file.  If neither "content" nor
#   "source" is given, the content of the file will be provided by this
#   module.
#
# [*source*]
#   URI of the journald.conf file content.  If neither "content" nor "source"
#   is given, the content of the file will be provided by this module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class systemd::journald (
        $enable=$::systemd::params::journald_enable,
        $ensure=$::systemd::params::journald_ensure,
        $content=undef,
        $source=undef,
    ) inherits ::systemd::params {

    include '::systemd'

    if $content or $source {
        $source_ = $source
    } else {
        $source_ = 'puppet:///modules/systemd/journald.conf'
    }

    file {
        default:
            owner     => 'root',
            group     => 'root',
            mode      => '0644',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'etc_t',
            before    => Service[$::systemd::params::journald_services],
            notify    => Service[$::systemd::params::journald_services],
            subscribe => Package[$::systemd::params::packages],
            ;
        '/etc/systemd/journald.conf':
            content => $content,
            source  => $source_,
            ;
    }

    service { $::systemd::params::journald_services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }


}
