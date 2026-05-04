require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Example < CLI::Kit::BaseCommand
      def call(_args, _name)
        puts 'neato'

        if rand < 0.05
          raise(CLI::Kit::Abort, "you got unlucky!")
        end
      end

      def self.help
        "A dummy command.\nUsage: {{command:#{TickGitBoom::TOOL_NAME} example}}"
      end
    end
  end
end
