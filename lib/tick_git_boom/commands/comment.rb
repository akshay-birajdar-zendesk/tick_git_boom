require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Comment < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end

        def body
          position!(desc: 'Comment text')
        end
      end

      desc 'Add a comment to a ticket'
      long_desc <<~DESC
        Appends a comment to the ticket and saves the runtime file.
        The author is taken from $USER.
      DESC
      usage 'ID BODY [--format auto|table|json]'
      example 'ZEN-001 "The queue remains suspiciously turbulent."', 'Comment on a ticket'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.add_comment(author: ENV['USER'] || 'you', body: op.body)
        store.save
        TicketOutput.show(ticket, format: op.format, message: "Added a comment to #{ticket.id}.")
      end
    end
  end
end
