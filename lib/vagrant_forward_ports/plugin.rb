require 'vagrant'

module VagrantForwardPorts
  class Plugin < Vagrant.plugin('2')
    name 'forward_ports'

    action_hook('foward_ports_configure') do |hook|
      # Hook for VirtualBox and HyperV
      hook.after(Vagrant::Action::Builtin::WaitForCommunicator,
                 Action.callback)

      # Hook for Azure plugins
      if defined?(VagrantPlugins::Azure)
        hook.after(VagrantPlugins::Azure::Action::RunInstance, Action.callback)
        hook.after(VagrantPlugins::Azure::Action::StartInstance, Action.callback)
      end
    end

    config(:forward_ports) do
      Config
    end

    command(:'forward-ports') do
      Command
    end
  end
end
