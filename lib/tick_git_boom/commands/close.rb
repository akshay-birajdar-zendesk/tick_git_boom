require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Close < CLI::Kit::BaseCommand
      class Opts < CLI::Kit::Opts
        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end
      end

      desc 'Close a ticket'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.close
        store.save
        TicketOutput.show(ticket, message: "Closed #{ticket.id}.")
      end
    end
  end
end
