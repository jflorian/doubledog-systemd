#
# == Type: systemd::rate
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


type Systemd::Rate = Variant[
    Integer[0],
    Pattern[
        /\A\d+(min|ms|us|[sh])\Z/,
    ],
]
