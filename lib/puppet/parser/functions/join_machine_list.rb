module Puppet::Parser::Functions
  newfunction(:join_machine_list, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "join_machine_list() wrong number of arguments. Given: #{args.size} for 2)") if args.size !=2
    prefix = args[0]
    machine_list = args[1]
    new_machine_list = Array.new
    
    machine_list.each do |item|
      machine = prefix + item
      new_machine_list.push machine
    end

    return new_machine_list.join(", ")
  end
end
