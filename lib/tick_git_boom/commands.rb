require 'tick_git_boom'

module TickGitBoom
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(default: 'help')

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(->() { const_get(const) }, cmd)
    end

    register :List,    'list',    'tick_git_boom/commands/list'
    register :Show,    'show',    'tick_git_boom/commands/show'
    register :Search,  'search',  'tick_git_boom/commands/search'
    register :Assign,  'assign',  'tick_git_boom/commands/assign'
    register :Comment, 'comment', 'tick_git_boom/commands/comment'
    register :Close,   'close',   'tick_git_boom/commands/close'
    register :Boom,    'boom',    'tick_git_boom/commands/boom'
    register :Help,    'help',    'tick_git_boom/commands/help'

    Registry.add_alias('--help', 'help')
    Registry.add_alias('-h', 'help')
  end
end
