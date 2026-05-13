require 'tick_git_boom'

module TickGitBoom
  module Commands
    class List < CLI::Kit::BaseCommand
      desc 'List every ticket'

      def call(_args, _name)
        TicketOutput.list(TicketStore.new.tickets)
      end
    end
  end
end
