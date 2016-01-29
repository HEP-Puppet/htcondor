require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe "join_machine_list function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  it "should exist" do
    expect(Puppet::Parser::Functions.function("join_machine_list")).to eq("function_join_machine_list")
  end
  machine_prefix = 'condor_pool@$(UID_DOMAIN)/'

  context 'join_machine_list tests' do
    it "single machine" do
      result = scope.function_join_machine_list([machine_prefix,['test1.example.com']])
      expect(result).to eq(machine_prefix + 'test1.example.com')
    end
    it "single machine different prefix" do
      prefix = 'root@$(UID_DOMAIN)/'
      result = scope.function_join_machine_list([prefix, ['test1.example.com']])
      expect(result).to eq(prefix + 'test1.example.com')
    end
    it "multiple machines" do
      result = scope.function_join_machine_list([machine_prefix,['test1.example.com', 'test2.example.com', 'test3.example.com']])
      expect(result).to eq('condor_pool@$(UID_DOMAIN)/test1.example.com, condor_pool@$(UID_DOMAIN)/test2.example.com, condor_pool@$(UID_DOMAIN)/test3.example.com')
    end
  end
end

