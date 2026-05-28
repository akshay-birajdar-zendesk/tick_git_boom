require 'tick_git_boom'

module TickGitBoom
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(default: 'help')

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(->() { const_get(const) }, cmd)
    end

    register :Help,    'help',    'tick_git_boom/commands/help'
    register :Search,  'search',  'tick_git_boom/commands/search'
  end
end
