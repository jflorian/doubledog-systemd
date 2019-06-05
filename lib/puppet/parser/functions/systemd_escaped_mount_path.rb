#
# == Function: systemd_escaped_mount_path
#
# Escape a file system path for a mount point per systemd rules.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-systemd Puppet module.
# Copyright 2016-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


require 'puppet/util/execution'

module Puppet::Parser::Functions
    newfunction(:systemd_escaped_mount_path, :type => :rvalue, :doc => <<-EOS
Returns a file system path mount point as escaped by systemd.

See SYSTEMD-ESCAPE(1) for details.
EOS
    ) do |args|

        unless args.size == 1
            raise(Puppet::ParseError, "systemd_escaped_mount_path(): " +
                "Wrong number of arguments given (#{args.size} for 1)")
        end

        path = args[0]

        unless path.is_a?(String)
            raise(Puppet::ParseError, 'systemd_escaped_mount_path(): " +
                  "Requires a string to work with')
        end

        cmd = "systemd-escape --path --suffix=mount #{path}"
        result = Puppet::Util::Execution.execute(cmd)

        return result.chomp

    end
end
