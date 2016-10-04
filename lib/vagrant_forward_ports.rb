begin
  require 'vagrant'
rescue LoadError
  raise 'This plugin must run within Vagrant.'
end

module VagrantForwardPorts
  autoload :Plugin, 'vagrant_forward_ports/plugin'
  autoload :Config, 'vagrant_forward_ports/config'
  autoload :Action, 'vagrant_forward_ports/action'
  autoload :Command, 'vagrant_forward_ports/command'
  autoload :VERSION, 'vagrant_forward_ports/version'
end

VagrantForwardPorts::Plugin
