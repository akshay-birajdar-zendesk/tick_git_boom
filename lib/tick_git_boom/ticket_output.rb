require 'tick_git_boom'
require 'json'

module TickGitBoom
  # Turns tickets into terminal output. The data model stays in Ticket;
  # everything about presentation lives here.
  #
  # In JSON mode, never open a CLI::UI frame on stdout: the StdoutRouter
  # prefixes every line with the frame border, inside the JSON.
  module TicketOutput
    FORMATS = %w[auto table json].freeze
    HEADINGS = %w[ID STATUS PRIORITY ASSIGNEE].freeze
    MIN_SUBJECT_WIDTH = 24
    # Status colours for the detail view.
    STATUS_COLOURS = { 'open' => :green, 'pending' => :yellow, 'closed' => :red }.freeze

    class << self
      def resolve(format)
        unless FORMATS.include?(format)
          raise(CLI::Kit::Abort, "unknown format #{format.inspect}; expected one of #{FORMATS.join(', ')}")
        end
        return format.to_sym unless format == 'auto'

        $stdout.tty? ? :table : :json
      end

      def list(tickets, format:)
        return puts(CLI::UI.fmt('{{gray:No tickets to show.}}')) if tickets.empty? && !json?(format)

        json?(format) ? puts(JSON.generate(tickets.map(&:to_h))) : table(tickets)
      end

      def show(ticket, format:, message: nil)
        json?(format) ? puts(JSON.generate(ticket.to_h)) : detail(ticket, message)
      end

      def notice(payload, format:, message:)
        return puts(JSON.generate(payload)) if json?(format)

        CLI::UI::Frame.open(TickGitBoom::TOOL_NAME, color: :green) { puts(CLI::UI.fmt(message)) }
      end

      private

      def json?(format)
        resolve(format) == :json
      end

      def table(tickets)
        lead = tickets.map { |t| [t.id, t.status, t.priority.to_s, t.assignee.to_s] }
        widths = ([HEADINGS] + lead).transpose.map { |col| col.map(&:length).max }

        # Subject takes the terminal's remaining width, so rows never wrap.
        budget = [CLI::UI::Terminal.width - widths.sum - widths.size - 1, MIN_SUBJECT_WIDTH].max

        rows = [(HEADINGS + ['SUBJECT']).map { |h| "{{bold:#{h}}}" }]
        rows += tickets.zip(lead).map do |ticket, cells|
          cells + [CLI::UI::Truncater.call(ticket.subject, budget)]
        end
        CLI::UI::Table.puts_table(rows)
      end

      def detail(ticket, message)
        CLI::UI::Frame.open("{{bold:#{ticket.id}}}  #{ticket.subject}", color: :cyan) do
          fields = [
            ['Status', ticket.status],
            ['Priority', ticket.priority],
            ['Requester', ticket.requester],
            ['Assignee', ticket.assignee],
            ['Tags', ticket.tags.join(', ')],
          ]
          label = fields.map { |name, _| name.length }.max + 3
          fields.each do |name, value|
            shown = value.to_s.empty? ? '{{gray:—}}' : field_value(name, value)
            puts(CLI::UI.fmt("{{bold:#{name.ljust(label)}}}#{shown}"))
          end

          puts('')
          puts(CLI::UI.fmt("{{bold:Comments (#{ticket.comments.size})}}"))
          ticket.comments.each do |comment|
            puts('')
            puts(CLI::UI.fmt("{{cyan:#{comment['author']}}}"))
            wrapped(comment['body'], indent: 2).each { |line| puts(line) }
          end

          puts(CLI::UI.fmt("\n{{green:#{message}}}")) if message
        end
      end

      def wrapped(text, indent:)
        pad = ' ' * indent
        CLI::UI::Wrap.new(text.to_s).wrap(CLI::UI::Terminal.width - indent)
          .lines.map { |line| pad + line.chomp }
      end

      # Colour a status value; every other field prints as given.
      def field_value(name, value)
        return value unless name == 'Status'

        "{{#{STATUS_COLOURS.fetch(value, :bold)}:#{value}}}"
      end
    end
  end
end
