require 'spec_helper'

describe 'systemd::mount' do
  let(:title) { '/var/mnt/test' }

  let(:facts) {{
    :osfamily => 'RedHat'
  }}

  context 'ensure => present' do
    let(:params) {{
      :ensure   => 'present',
      :enable   => true,
      :mnt_what => '/dev/sdb1',
      :mnt_description => 'secondary data drive',
    }}

    it do
      is_expected.to contain_systemd__unit('var-mnt-test.mount') .with({ 'ensure' => 'present' })
    end
  end

  context 'ensure => absent' do
    let(:params) {{
      :ensure => 'absent',
      :enable   => false,
      :mnt_what => '/dev/sdb1',
      :mnt_description => 'secondary data drive',
    }}

    it do
      is_expected.to contain_systemd__unit('var-mnt-test.mount') .with({ 'ensure' => 'absent' })
    end
  end

end
