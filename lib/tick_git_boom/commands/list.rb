require 'tick_git_boom'

module TickGitBoom
  module Commands
    class List < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts
      end

      desc 'List every ticket'
      long_desc <<~DESC
        Prints every ticket in the runtime file, newest last, in the order it is stored.
      DESC
      usage '[--format auto|table|json]'
      example '--format json', 'Machine-readable list'

      def invoke(op, _name)
        TicketOutput.list(TicketStore.new.tickets, format: op.format)
      end
    end
  end
end
