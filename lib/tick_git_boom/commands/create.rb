require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Create < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def subject
          position(desc: 'What the ticket is about; omit it with --interactive')
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

        def interactive
          flag(short: '-i', long: '--interactive', desc: 'Ask for each field instead of passing flags')
        end
      end

      desc 'Create a new ticket'
      long_desc <<~DESC
        Creates an open, unassigned ticket with the next ID in the sequence
        and saves it to the runtime file. Also available as `add`.
      DESC
      usage 'SUBJECT [--priority high|normal|low] [--requester NAME] [--tags a,b] [--format auto|table|json]'
      usage '--interactive [--format auto|table|json]'
      example '"Queue velocity appears turbulent"', 'Create a ticket'
      example '"Search is literal" --priority low --tags search,index', 'Create with priority and tags'
      example '--interactive', 'Fill the fields in by prompt'

      def invoke(op, _name)
        attributes = op.interactive ? prompt(op) : flags(op)

        store = TicketStore.new
        ticket = store.create(**attributes)
        store.save
        TicketOutput.show(ticket, format: op.output_format, message: "Created #{ticket.id}.")
      end

      private

      def flags(op)
        {
          subject: op.subject || raise(CLI::Kit::Abort, 'give a SUBJECT, or use --interactive'),
          priority: validated(op.priority),
          requester: op.requester,
          tags: split_tags(op.tags),
        }
      end

      # Prompts write to stdout, so they cannot share it with JSON output.
      def prompt(op)
        raise(CLI::Kit::Abort, '--interactive needs a terminal') unless $stdout.tty?
        raise(CLI::Kit::Abort, '--interactive cannot be used with --format json') if
          TicketOutput.resolve(op.output_format) == :json

        {
          subject: CLI::UI::Prompt.ask('Subject?', allow_empty: false),
          priority: CLI::UI::Prompt.ask('Priority?', options: Ticket::PRIORITIES),
          requester: CLI::UI::Prompt.ask('Requester?', default: ENV['USER'] || 'you'),
          tags: split_tags(CLI::UI::Prompt.ask('Tags? (comma separated, may be empty)', allow_empty: true)),
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
