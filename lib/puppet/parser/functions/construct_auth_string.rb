module Puppet::Parser::Functions
  newfunction(:construct_auth_string, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "construct_auth_string() wrong number of arguments. Given: #{args.size} for 4)") if args.size != 4
    use_fs_auth = args[0]
    use_password_auth = args[1]
    use_kerberos_auth = args[2]
    use_claim_to_be_auth = args[3]

    fs_string = 'FS'
    pw_string = 'PASSWORD'
    krb_string = 'KERBEROS'
    ctb_string = 'CLAIMTOBE'

    auth_methods = Array.new
    if use_fs_auth == true
      auth_methods.push fs_string
    end
    if use_password_auth == true
      auth_methods.push pw_string
    end
    if use_kerberos_auth == true
      auth_methods.push krb_string
    end
    if use_claim_to_be_auth == true
      auth_methods.push ctb_string
    end

    return auth_methods.join(",")
  end
end
