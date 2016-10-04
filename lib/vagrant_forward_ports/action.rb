require 'vagrant'

module VagrantForwardPorts
  class Action
    include Vagrant::Errors

    def self.callback
      cb = Vagrant::Action::Builder.new.tap do |b|
        b.use Action
      end
    end

    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      ssh_opts = create_forwards(env)

      unless ssh_opts.empty?
        run_ssh(env, ssh_opts)
      end

      @app.call(env)
    end

    def create_forwards(env)
      ssh_opts = { }
      extra_args = [ ]

      config = env[:machine].config.forward_ports

      forwards = config.forwards
      unless forwards.nil? || forwards.empty?
        extra_args += forwards.collect { |map|
          '-L %s:%s' % [ map[:from], map[:to] ] }
      end

      reverses = config.reverses
      unless reverses.nil? || reverses.empty?
        extra_args += reverses.collect { |map|
          '-R %s:%s' % [ map[:from], map[:to] ] }
      end

      unless extra_args.empty?
        extra_args += [ '-f', '-N' ]
        ssh_opts[:extra_args] = extra_args
      end

      ssh_opts
    end

    def run_ssh(env, ssh_opts)
      info = get_and_check_info(env)

      @env[:ui].info('Creating port forwards with SSH: %s' %
                     ssh_opts[:extra_args].join(' '))

      ssh_opts[:subprocess] = true
      env[:ssh_run_exit_status] = Vagrant::Util::SSH.exec(info, ssh_opts)
    end

    def get_and_check_info(env)
      info = env[:ssh_info]
      info ||= env[:machine].ssh_info

      raise Errors::SSHNotReady if info.nil?

      info[:private_key_path] ||= [ ]
      if info[:keys_only] && info[:private_key_path].empty?
        raise Errors::SSHRunRequiresKeys
      end

      info
    end
  end
end
