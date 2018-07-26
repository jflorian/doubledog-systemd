require 'spec_helper'

describe 'systemd::logind' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:params) {{
        :service => 'test.service',
      #  :handle_hibernate_key => :undef,
      #  :handle_lid_switch => :undef,
      #  :handle_lid_switch_docked => :undef,
      #  :handle_power_key => :undef,
      #  :handle_suspend_key => :undef,
      #  :idle_action => :undef,
      #  :hibernate_key_ignore_inhibited => :undef,
      #  :holdoff_timeout_sec => :undef,
      #  :idle_action_sec => :undef,
      #  :inhibit_delay_max_sec => :undef,
      #  :kill_exclude_users => :undef,
      #  :kill_only_users => :undef,
      #  :kill_user_processes => :undef,
      #  :lid_switch_ignore_inhibited => :undef,
      #  :n_auto_vts => :undef,
      #  :power_key_ignore_inhibited => :undef,
      #  :remove_ipc => :undef,
      #  :reserve_vt => :undef,
      #  :runtime_directory_size => :undef,
      #  :suspend_key_ignore_inhibited => :undef,
      }}

      it do
        is_expected.to contain_file("/etc/systemd/logind.conf")
            .with({
              "owner"   => "root",
              "group"   => "root",
              "mode"    => "0644",
              "seluser" => "system_u",
              "selrole" => "object_r",
              "seltype" => "etc_t",
            })
      end

      it do
        is_expected.to contain_service('test.service')
            .with({
              "ensure"     => nil,
              "enable"     => nil,
              "hasrestart" => true,
              "hasstatus"  => true,
            })
      end
    end
  end
end
