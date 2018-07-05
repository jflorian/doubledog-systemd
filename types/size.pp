#
# == Type: systemd::size
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


type Systemd::Size = Variant[
    Integer[0],
    Pattern[
        /\A\d+[KMGTPE]\Z/,
    ],
]
