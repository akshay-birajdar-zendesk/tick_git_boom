require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Search < CLI::Kit::BaseCommand
      class Opts < CLI::Kit::Opts
        def query
          position!(desc: 'Text to match against ticket subjects')
        end
      end

      desc 'Search ticket subjects'

      def invoke(op, _name)
        matches = TicketStore.new.tickets.select { |t| t.matches?(op.query) }
        matches.each { |t| puts "#{t.id}  #{t.status}  #{t.subject}" }
      end
    end
  end
end
