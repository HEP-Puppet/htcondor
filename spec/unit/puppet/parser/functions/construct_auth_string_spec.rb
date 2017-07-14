require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe "construct_auth_string function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  it "should exist" do
    expect(Puppet::Parser::Functions.function("construct_auth_string")).to eq("function_construct_auth_string")
  end

  context 'construct_auth_string test' do
    it "get FS right" do
      result = scope.function_construct_auth_string([true, false, false, false, false, false])
      expect(result).to eq('FS')
    end
    it "get FS,PASSWORD right" do
      result = scope.function_construct_auth_string([true, true, false, false, false, false])
      expect(result).to eq('FS,PASSWORD')
    end
    it "get FS,PASSWORD,KERBEROS right" do
      result = scope.function_construct_auth_string([true, true, true, false, false, false])
      expect(result).to eq('FS,PASSWORD,KERBEROS')
    end
    it "get FS,PASSWORD,KERBEROS,CLAIMTOBE right" do
      result = scope.function_construct_auth_string([true, true, true, true, false, false])
      expect(result).to eq('FS,PASSWORD,KERBEROS,CLAIMTOBE')
    end
    it "get FS,PASSWORD,KERBEROS,CLAIMTOBE,ANONYMOUS right" do
      result = scope.function_construct_auth_string([true, true, true, true, true, false])
      expect(result).to eq('FS,PASSWORD,KERBEROS,CLAIMTOBE,ANONYMOUS')
    end
    it "get FS,PASSWORD,KERBEROS,CLAIMTOBE,ANONYMOUS,SSL right" do
      result = scope.function_construct_auth_string([true, true, true, true, true, true])
      expect(result).to eq('FS,PASSWORD,KERBEROS,CLAIMTOBE,ANONYMOUS,SSL')
    end
    it "get FS,KERBEROS right" do
      result = scope.function_construct_auth_string([true, false, true, false, false, false])
      expect(result).to eq('FS,KERBEROS')
    end
  end
end
