require 'spec_helper'

describe 'systemd::unit' do
  let(:title) { 'test_unit' }

  let(:params) {{
    :ensure => 'present',
    :enable => true,
    :source => 'puppet:///modules/example/systemd/test_unit.unit',
  }}

  context "ensure => present, enable => true" do
    let(:params) {{
      :ensure => 'present',
      :enable => true,
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
      is_expected.to contain_file("/etc/systemd/system/#{title}")
          .with({
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'seluser' => 'system_u',
            'selrole' => 'object_r',
            'seltype' => 'systemd_unit_file_t',
            :source   => 'puppet:///modules/example/systemd/test_unit.unit',
          })
    end

    it do
      is_expected.to contain_exec("systemctl enable '#{title}'")
          .with({
            "unless" => "systemctl is-enabled '#{title}'",
          })
          .that_requires('Class[systemd::daemon]')
    end

    it do
      is_expected.to contain_exec("systemctl reenable '#{title}'")
          .with({
            :refreshonly => true,
          })
          .that_requires('Class[systemd::daemon]')
          .that_subscribes_to("Exec[systemctl restart '#{title}']")
    end

    it do
      is_expected.to contain_exec("systemctl start '#{title}'")
          .with({
            "unless" => "systemctl is-active '#{title}'",
          })
    end

    it do
      is_expected.to contain_exec("systemctl restart '#{title}'") .with({ "refreshonly" => true })
    end
  end

  context "ensure => present, enable => false" do
    let(:params) {{
      :ensure => 'present',
      :enable => false,
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
      is_expected.to contain_file("/etc/systemd/system/#{title}")
          .with({
            "ensure"    => "present",
            "owner"     => "root",
            "group"     => "root",
            "mode"      => "0644",
            "seluser"   => "system_u",
            "selrole"    => "object_r",
            "seltype"   => "systemd_unit_file_t",
            "source"    => 'puppet:///modules/example/systemd/test_unit.unit',
          })
    end

    it do
      is_expected.to contain_exec("systemctl disable '#{title}'") .with({ "onlyif" => "systemctl is-enabled '#{title}'" })
    end

    it do
      is_expected.to contain_exec("systemctl start '#{title}'") .with({ "unless" => "systemctl is-active '#{title}'" })
    end

    it do
      is_expected.to contain_exec("systemctl restart '#{title}'") .with({ "refreshonly" => true })
    end
  end

  context "ensure => absent" do
    let(:params) {{
      :ensure => 'absent',
      :enable => false,
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
        is_expected.to contain_file("/etc/systemd/system/#{title}") .with({ "ensure" => "absent" })
    end

    it do
      is_expected.to contain_exec("systemctl disable '#{title}'") .with({ "onlyif" => "test -e '/etc/systemd/system/#{title}'" })
        .that_comes_before("File[/etc/systemd/system/#{title}]")
    end

    it do
      is_expected.to contain_exec("systemctl stop '#{title}'") .with({ "onlyif" => "test -e '/etc/systemd/system/#{title}'" })
        .that_comes_before("File[/etc/systemd/system/#{title}]")
    end
  end

  it do
    is_expected.to contain_exec("make unit path for #{title}")
        .with({
          "command" => "mkdir -p '/etc/systemd/system'",
          "unless"  => "test -d '/etc/systemd/system'",
        })
        .that_comes_before("File[/etc/systemd/system/#{title}]")
  end

  context "ensure => present, enable => true, extends => test" do
    let(:params) {{
      :ensure => 'present',
      :enable => true,
      :extends => 'test',
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
      is_expected.to contain_file("/etc/systemd/system/test.d/#{title}")
          .with({
            "ensure" => "present",
            "owner" => "root",
            "group" => "root",
            "mode" => "0644",
            "seluser" => "system_u",
            "selrole" => "object_r",
            "seltype" => "systemd_unit_file_t",
            "source" => 'puppet:///modules/example/systemd/test_unit.unit',
          })
    end

    it do
      is_expected.to contain_exec("systemctl enable 'test'") .with({ "unless" => "systemctl is-enabled 'test'" })
    end

    it do
      is_expected.to contain_exec("systemctl reenable 'test'")
    end

    it do
      is_expected.to contain_exec("systemctl start 'test'") .with({ "unless" => "systemctl is-active 'test'" })
    end

    it do
      is_expected.to contain_exec("systemctl restart 'test'") .with({ "refreshonly" => true })
    end
  end

  context "ensure => absent, enable => false, extends => test" do
    let(:params) {{
      :ensure => 'absent',
      :enable => false,
      :extends => 'test',
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
      is_expected.to contain_file("/etc/systemd/system/test.d/#{title}") .with({ "ensure" => "absent" })
    end
  end

  context "ensure => absent, enable => false, extends => undef" do
    let(:params) {{
      :ensure => 'absent',
      :enable => false,
      :extends => :undef,
      :source => 'puppet:///modules/example/systemd/test_unit.unit',
    }}

    it do
      is_expected.to contain_exec("systemctl disable '#{title}'") .with({ "onlyif" => "test -e '/etc/systemd/system/#{title}'" })
        .that_comes_before("File[/etc/systemd/system/#{title}]")
    end

    it do
      is_expected.to contain_exec("systemctl stop '#{title}'") .with({ "onlyif" => "test -e '/etc/systemd/system/#{title}'" })
        .that_comes_before("File[/etc/systemd/system/#{title}]")
    end
  end
end
