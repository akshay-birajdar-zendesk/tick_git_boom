require 'cli/ui'
require 'cli/kit'

CLI::UI::StdoutRouter.enable

module TickGitBoom
  TOOL_NAME = 'tickgitboom'
  ROOT      = File.expand_path('../..', __FILE__)
  LOG_FILE  = '/tmp/tick_git_boom.log'

  SEED_PATH = File.join(ROOT, 'seeds', 'tickets.json')
  DATA_PATH = File.join(ROOT, 'data', 'tickets.json')

  autoload(:EntryPoint,   'tick_git_boom/entry_point')
  autoload(:Commands,     'tick_git_boom/commands')
  autoload(:Command,      'tick_git_boom/command')
  autoload(:FormatOpts,   'tick_git_boom/format_opts')
  autoload(:Ticket,       'tick_git_boom/ticket')
  autoload(:TicketStore,  'tick_git_boom/ticket_store')
  autoload(:TicketOutput, 'tick_git_boom/ticket_output')

  Config = CLI::Kit::Config.new(tool_name: TOOL_NAME)

  CLI::Kit::CommandHelp.tool_name = TOOL_NAME

  Executor = CLI::Kit::Executor.new(log_file: LOG_FILE)
  Resolver = CLI::Kit::Resolver.new(
    tool_name: TOOL_NAME,
    command_registry: TickGitBoom::Commands::Registry
  )

  ErrorHandler = CLI::Kit::ErrorHandler.new(log_file: LOG_FILE)
end
