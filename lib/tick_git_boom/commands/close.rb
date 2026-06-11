require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Close < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end
      end

      desc 'Close a ticket'
      long_desc <<~DESC
        Sets the ticket status to closed and saves the runtime file.
        There is no reopen command: run boom to reset everything.
      DESC
      usage 'ID [--format auto|table|json]'
      example 'ZEN-001', 'Close a ticket'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.close
        store.save
        TicketOutput.show(ticket, format: op.output_format, message: "Closed #{ticket.id}.")
      end
    end
  end
end
