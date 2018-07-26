require 'spec_helper'

describe 'systemd::daemon' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it do
        is_expected.to contain_exec("systemctl daemon-reload")
            .with({
              "refreshonly" => true,
            })
      end
    end
  end
end
