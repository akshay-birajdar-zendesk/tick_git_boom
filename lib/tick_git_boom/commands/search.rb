require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Search < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts

        def query
          position!(desc: 'Text to match against ticket subjects')
        end
      end

      desc 'Search ticket subjects'
      long_desc <<~DESC
        Matches the query against ticket subjects only, case-insensitively, as a substring.
        Comments and tags are not searched.
      DESC
      usage 'QUERY [--format auto|table|json]'
      example '"queue"', 'Find tickets about the queue'

      def invoke(op, _name)
        TicketOutput.list(TicketStore.new.tickets.select { |t| t.matches?(op.query) }, format: op.format)
      end
    end
  end
end
