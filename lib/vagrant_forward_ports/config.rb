require 'vagrant'

module VagrantForwardPorts
  class Config < Vagrant.plugin('2', :config)
    attr_reader :forwards
    attr_reader :reverses

    def maps(&block)
      block.call(self)
    end

    def forward(from, to)
      @forwards ||= [ ]
      @forwards << { from: from, to: to }
    end

    def reverse(from, to)
      @reverses ||= [ ]
      @reverses << { from: from, to: to }
    end
  end
end
