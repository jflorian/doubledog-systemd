#
# == Function: systemd::escape
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


Puppet::Functions.create_function(:'systemd::escape') do
  dispatch :escape do
    param 'String', :path
    optional_param 'String', :suffix
  end

  def escape(path, suffix='mount')

      cmd = "systemd-escape --path --suffix=#{suffix} #{path}"
      result = Puppet::Util::Execution.execute(cmd)

      return result.chomp

  end
end
