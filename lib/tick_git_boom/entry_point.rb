require 'tick_git_boom'

module TickGitBoom
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = TickGitBoom::Resolver.call(args)
      TickGitBoom::Executor.call(cmd, command_name, args)
    end
  end
end
