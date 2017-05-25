require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'
require 'rspec/mocks'
require 'rspec-puppet-facts'

# hack to enable all the expect syntax (like allow_any_instance_of) in rspec-puppet examples
RSpec::Mocks::Syntax.enable_expect(RSpec::Puppet::ManifestMatchers)

RSpec.configure do |c|
  c.add_setting :puppet_future
  c.puppet_future = Puppet.version.to_f >= 4.0

  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
    # Store any environment variables away to be restored later
    @old_env = {}
    ENV.each_key {|k| @old_env[k] = ENV[k]}
    if ENV['STRICT_VARIABLES'] == 'yes'
      Puppet.settings[:strict_variables]=true
    end
    RSpec::Mocks.setup
  end

  c.after :each do
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end
