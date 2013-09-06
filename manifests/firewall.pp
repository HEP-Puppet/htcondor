#
# Class htcondor::firewall
# Defines firewall rules for the HTCondor server (CE)
#
class htcondor::firewall (
  $worker_nodes_network = '127.0.0.1') {
  firewall { '200 Allow worker nodes to contact server':
    action => 'accept',
    source => $worker_nodes_network,
    proto  => 'tcp',
    state  => [
      'ESTABLISHED',
      'NEW'],
    dport  => '9000-10000',
  }

  firewall { '201 Allow worker nodes to contact server':
    action => 'accept',
    source => $worker_nodes_network,
    proto  => 'tcp',
    state  => [
      'ESTABLISHED',
      'NEW'],
    dport  => '9000-10000',
  }

}
