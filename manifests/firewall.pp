#
# Class htcondor::firewall
# Defines firewall rules for the HTCondor server (CE)
#
class htcondor::firewall (
  $worker_nodes_network = '127.0.0.1/32') {
  firewall { '200 Allow worker nodes to contact server':
    action => 'accept',
    source => $worker_nodes_network,
    proto  => 'all',
    state  => [
      'ESTABLISHED',
      'NEW'],
    dport  => '9000-1000',
  }
}
