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
      with_target_vms do |vm|
        check_runable_on(vm)

        ssh_opts = action.create_forwards(vm)

        unless ssh_opts.empty?
          @action.run_ssh(vm, ssh_opts)
        end
      end
    end

    def action
      if defined?(@action) && !@action.nil?
        @action
      else
        @action = Action.new(nil, nil)
      end
    end
  end
end
