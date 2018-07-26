require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'
require 'rspec-puppet-facts'
include RspecPuppetFacts

# Uncomment this to show coverage report, also useful for debugging
at_exit { RSpec::Puppet::Coverage.report! }

# set to the desired ordering method ("title-hash", "manifest", or "random") to set the order of unrelated resources
# when applying a catalog. Leave unset for the default behavior, currently "random". This is equivalent to setting
# ordering in puppet.conf.
ENV['ORDERING'] = 'random'

# set to "no" to enable structured facts, otherwise leave unset to retain the current default behavior.
# This is equivalent to setting stringify_facts=false in puppet.conf.
ENV['STRINGIFY_FACTS']  = 'no'

RSpec.configure do |c|
    c.formatter = 'documentation'
    c.mock_with :rspec
    c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
    c.expect_with :rspec do |expectations|
      expectations.syntax = [:should, :expect]
    end
    c.fail_fast = 1
end
