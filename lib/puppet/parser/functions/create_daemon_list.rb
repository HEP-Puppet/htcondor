module Puppet::Parser::Functions
  newfunction(:create_daemon_list, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "create_daemon_list() wrong number of arguments. Given: #{args.size} for 6)") if args.size != 6
    is_worker = args[0]
    is_scheduler = args[1]
    is_manager = args[2]

    defrag = args[3]
    ganglia = args[4]
    high_availability= args[5]

    default_list = ['MASTER']
    worker_daemon_list  = ['STARTD']
    sched_daemon_list     = ['SCHEDD']
    manage_daemon_list = ['COLLECTOR', 'NEGOTIATOR']
    ganglia_daemon_list   = ['GANGLIAD']
    #HAD, REPLICATION

    daemon_list = Array.new
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
    if defrag == true
      daemon_list.push 'DEFRAG'
    end
    if ganglia == true
      daemon_list.push 'GANGLIAD'
    end
    if high_availability == true
      high_availability.push 'HAD'
      high_availability.push 'REPLICATION'
    end

    return daemon_list.join(", ")
  end
end
