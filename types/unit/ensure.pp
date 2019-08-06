#
# == Type: Systemd::Unit::Ensure
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


type Systemd::Unit::Ensure = Enum[
    'absent',
    'present',
    'running',
    'started',
    'stopped',
]
