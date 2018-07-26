require 'spec_helper'

describe 'systemd::journald' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it do
        is_expected.to contain_file("/etc/systemd/journald.conf")
      end

      it do
        is_expected.to contain_service('systemd-journald')
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
