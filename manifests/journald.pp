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
        $content=undef,
        String[1]   $service,
        $source=undef,
    ) {

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
            before    => Service[$service],
            notify    => Service[$service],
            subscribe => Package[$::systemd::packages],
            ;
        '/etc/systemd/journald.conf':
            content => $content,
            source  => $source_,
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
