require 'tick_git_boom'
require 'json'

module TickGitBoom
  # Turns tickets into terminal output. The data model stays in Ticket;
  # everything about presentation lives here.
  module TicketOutput
    HEADINGS = %w[ID STATUS PRIORITY ASSIGNEE].freeze

    class << self
      def list(tickets)
        table(tickets)
      end

      def show(ticket, message: nil)
        detail(ticket, message)
      end

      private

      def table(tickets)
        lead = tickets.map { |t| [t.id, t.status, t.priority.to_s, t.assignee.to_s] }
        widths = ([HEADINGS] + lead).transpose.map { |col| col.map(&:length).max }

        # Subject takes the terminal's remaining width, so rows never wrap.
        budget = [CLI::UI::Terminal.width - widths.sum - widths.size - 1, 20].max

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
          label = fields.map { |name, _| name.length }.max + 2
          fields.each do |name, value|
            puts(CLI::UI.fmt("{{bold:#{name.ljust(label)}}}#{value}"))
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
    end
  end
end
