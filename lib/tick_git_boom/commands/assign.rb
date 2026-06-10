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
      long_desc <<~DESC
        Sets the assignee and saves the runtime file. The name is stored as given, trimmed;
        it is not checked against a list of people.
      DESC
      usage 'ID ASSIGNEE [--format auto|table|json]'
      example 'ZEN-001 "George Stokes"', 'Reassign a ticket'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.assignee = op.assignee
        store.save
        TicketOutput.show(ticket, format: op.output_format, message: "Assigned #{ticket.id} to #{ticket.assignee}.")
      end
    end
  end
end
