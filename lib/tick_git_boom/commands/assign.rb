require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Assign < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end

        def assignee
          position!(desc: 'Person to assign the ticket to')
        end
      end

      desc 'Assign a ticket to someone'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.assignee = op.assignee
        store.save
        TicketOutput.show(ticket, format: op.format, message: "Assigned #{ticket.id} to #{ticket.assignee}.")
      end
    end
  end
end
