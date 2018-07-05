#
# == Type: systemd::journald::level
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


type Systemd::Journald::Level = Variant[
    Integer[0, 7],
    Enum[
        'emerg',    # 0
        'alert',    # 1
        'crit',     # 2
        'err',      # 3
        'warning',  # 4
        'notice',   # 5
        'info',     # 6
        'debug',    # 7
    ],
]
