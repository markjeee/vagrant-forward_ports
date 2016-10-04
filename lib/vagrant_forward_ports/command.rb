require 'vagrant'

module VagrantForwardPorts
  class Command < Vagrant.plugin('2', :command)
    include Vagrant::Errors

    def self.synopsis
      'Creates the configured port forwards between the guest and the host machines'
    end

    def check_runable_on(vm)
      raise VMNotCreatedError if vm.state.id == :not_created
      raise VMInaccessible if vm.state.id == :inaccessible
      raise VMNotRunningError if vm.state.id != :running
    end

    def execute
      puts 'Hello World'
    end
  end
end
