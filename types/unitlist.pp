#
# == Type: systemd::unitlist
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


type Systemd::Unitlist = Variant[
    String[1],
    Array[String[1]],
]
