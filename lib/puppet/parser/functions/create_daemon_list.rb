module Puppet::Parser::Functions
  # rubocop:disable Style/HashSyntax
  newfunction(
    :create_daemon_list,
    :type => :rvalue,
    :doc => 'Parses bool array of enabled roles into a comma-separated list of condor daemons',
  ) do |args|
    # rubocop:enable Style/HashSyntax
    raise(Puppet::ParseError, "create_daemon_list() wrong number of arguments. Given: #{args.size} for 6)") if args.size != 6
    is_worker = args[0]
    is_scheduler = args[1]
    is_manager = args[2]

    enable_multicore = args[3]
    run_ganglia = args[4]
    more_than_two_managers = args[5]

    daemon_list = []
    # all nodes have master
    daemon_list.push 'MASTER'

    if is_worker == true
      daemon_list.push 'STARTD'
    end
    if is_scheduler == true
      daemon_list.push 'SCHEDD'
    end
    if is_manager == true
      daemon_list.push 'COLLECTOR'
      daemon_list.push 'NEGOTIATOR'
    end
    if enable_multicore == true && is_manager == true
      daemon_list.push 'DEFRAG'
    end
    if run_ganglia == true && (is_manager == true || is_scheduler == true)
      daemon_list.push 'GANGLIAD'
    end
    if more_than_two_managers == true && is_manager == true
      daemon_list.push 'HAD'
      daemon_list.push 'REPLICATION'
    end

    return daemon_list.join(', ')
  end
end
