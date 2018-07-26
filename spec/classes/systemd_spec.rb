require 'spec_helper'

describe 'systemd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_class('systemd::daemon') }
      it { is_expected.to contain_exec('systemctl daemon-reload') }

      it do
        is_expected.to contain_package("systemd")
            .with({
              "ensure" => "installed",
            })
      end
    end
  end
end
