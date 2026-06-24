require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Add < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def subject
          position!(desc: 'What the ticket is about')
        end

        def priority
          option!(long: '--priority', desc: Ticket::PRIORITIES.join('|'), default: 'normal')
        end

        def requester
          option!(long: '--requester', desc: 'Who reported it', default: -> { ENV['USER'] || 'you' })
        end

        def tags
          option(long: '--tags', desc: 'Comma-separated tags')
        end
      end

      desc 'Create a new ticket'
      long_desc <<~DESC
        Creates an open, unassigned ticket with the next ID in the sequence
        and saves it to the runtime file.
      DESC
      usage 'SUBJECT [--priority high|normal|low] [--requester NAME] [--tags a,b] [--format auto|table|json]'
      example '"Queue velocity appears turbulent"', 'Create a ticket'
      example '"Search is literal" --priority low --tags search,index', 'Create with priority and tags'

      def invoke(op, _name)
        attributes = flags(op)

        store = TicketStore.new
        ticket = store.create(**attributes)
        store.save
        TicketOutput.show(ticket, format: op.output_format, message: "Created #{ticket.id}.")
      end

      private

      def flags(op)
        {
          subject: op.subject || raise(CLI::Kit::Abort, 'give a SUBJECT'),
          priority: validated(op.priority),
          requester: op.requester,
          tags: split_tags(op.tags),
        }
      end

      def validated(priority)
        return priority if Ticket::PRIORITIES.include?(priority)

        raise(CLI::Kit::Abort, "unknown priority #{priority.inspect}; expected one of #{Ticket::PRIORITIES.join(', ')}")
      end

      def split_tags(value)
        value.to_s.split(',').map(&:strip).reject(&:empty?)
      end
    end
  end
end
