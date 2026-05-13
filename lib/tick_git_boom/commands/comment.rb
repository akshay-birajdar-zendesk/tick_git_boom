require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Comment < CLI::Kit::BaseCommand
      class Opts < CLI::Kit::Opts
        def id
          position!(desc: 'Ticket ID, e.g. ZEN-001')
        end

        def body
          position!(desc: 'Comment text')
        end
      end

      desc 'Add a comment to a ticket'

      def invoke(op, _name)
        store = TicketStore.new
        ticket = store.find(op.id)
        ticket.add_comment(author: ENV['USER'] || 'you', body: op.body)
        store.save
        TicketOutput.show(ticket, message: "Added a comment to #{ticket.id}.")
      end
    end
  end
end
