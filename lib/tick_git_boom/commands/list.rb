require 'tick_git_boom'

module TickGitBoom
  module Commands
    class List < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts
      end

      desc 'List every ticket'

      def invoke(op, _name)
        TicketOutput.list(TicketStore.new.tickets, format: op.format)
      end
    end
  end
end
