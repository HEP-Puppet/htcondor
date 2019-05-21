require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe 'create_daemon_list function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'exists' do
    expect(Puppet::Parser::Functions.function('create_daemon_list')).to eq('function_create_daemon_list')
  end

  context 'create_daemon_list test' do
    it 'worker list' do
      result = scope.function_create_daemon_list([true, false, false, false, false, false])
      expect(result).to eq('MASTER, STARTD')
    end
    it 'scheduler' do
      result = scope.function_create_daemon_list([false, true, false, false, false, false])
      expect(result).to eq('MASTER, SCHEDD')
    end
    it 'scheduler and ganglia' do
      result = scope.function_create_daemon_list([false, true, false, false, true, false])
      expect(result).to eq('MASTER, SCHEDD, GANGLIAD')
    end
    it 'manager' do
      result = scope.function_create_daemon_list([false, false, true, false, false, false])
      expect(result).to eq('MASTER, COLLECTOR, NEGOTIATOR')
    end
    it 'manager and ganglia' do
      result = scope.function_create_daemon_list([false, false, true, false, true, false])
      expect(result).to eq('MASTER, COLLECTOR, NEGOTIATOR, GANGLIAD')
    end
    it 'multicore manager' do
      result = scope.function_create_daemon_list([false, false, true, true, false, false])
      expect(result).to eq('MASTER, COLLECTOR, NEGOTIATOR, DEFRAG')
    end
    it 'multiple managers' do
      result = scope.function_create_daemon_list([false, false, true, false, false, true])
      expect(result).to eq('MASTER, COLLECTOR, NEGOTIATOR, HAD, REPLICATION')
    end
    it 'multiple managers and ganglia' do
      result = scope.function_create_daemon_list([false, false, true, false, true, true])
      expect(result).to eq('MASTER, COLLECTOR, NEGOTIATOR, GANGLIAD, HAD, REPLICATION')
    end
    it 'all the daemons' do
      result = scope.function_create_daemon_list([true, true, true, true, true, true])
      expect(result).to eq('MASTER, STARTD, SCHEDD, COLLECTOR, NEGOTIATOR, DEFRAG, GANGLIAD, HAD, REPLICATION')
    end
  end
end
