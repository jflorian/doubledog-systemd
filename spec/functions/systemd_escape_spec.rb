require 'spec_helper'

describe 'systemd::escape' do
  it { is_expected.to run.with_params('/var/mnt/foo', 'mount') }
end
