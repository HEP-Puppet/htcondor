# Fact: condor_version
#
# Purpose: Report the version of HTCondor
#
Facter.add(:condor_version) do
  setcode do
    begin
      Facter::Util::Resolution.exec("condor_version 2>&1").split("\n")[0].split(' ')[1] 
    rescue Exception
      Facter.debug('condor_version not available')
    end
  end
end
