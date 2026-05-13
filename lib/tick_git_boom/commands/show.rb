require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Show < CLI::Kit::BaseCommand
      class Opts < CLI::Kit::Opts
        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end
      end

      desc 'Show one ticket and its comments'

      def invoke(op, _name)
        TicketOutput.show(TicketStore.new.find(op.id))
      end
    end
  end
end
