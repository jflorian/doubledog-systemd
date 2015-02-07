#
# == Function: systemd_escaped_mount_path
#
# Escape a file system path for a mount point per systemd rules.
#
# === Parameters
#
# [*path*]
#   The mount point path that is to be escaped.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>


require 'puppet/util/execution'

module Puppet::Parser::Functions
    newfunction(:systemd_escaped_mount_path, :type => :rvalue, :doc => <<-EOS
Returns a file system path mount point as escaped by systemd.
EOS
    ) do |args|

        if (args.length != 1) then
            raise Puppet::ParseError, ("validate_cmd(): wrong number of arguments (#{args.length}; must be 1)")
        end

        path = args[0]

        cmd = "systemd-escape --path --suffix=mount #{path}"
        escaped = Puppet::Util::Execution.execute(cmd)

        return escaped

    end
end
