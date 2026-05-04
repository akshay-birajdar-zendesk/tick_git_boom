require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Help < CLI::Kit::BaseCommand
      SUMMARY = 'A small local support-ticket CLI for the Git scavenger hunt.'.freeze

      desc 'Show this help'

      def call(_args, _name)
        tool = TickGitBoom::TOOL_NAME

        puts CLI::UI.fmt("{{bold:#{tool}}} — #{SUMMARY}")
        puts ''
        puts CLI::UI.fmt('{{bold:Usage:}}')
        puts CLI::UI.fmt("  {{command:#{tool}}} {{yellow:COMMAND}} [ARGS]")
        puts ''
        puts CLI::UI.fmt('{{bold:Commands:}}')
        commands.each do |name, klass|
          puts CLI::UI.fmt("  {{command:#{name.ljust(width)}}}  #{klass._desc}")
        end
      end

      private

      def commands
        @commands ||= TickGitBoom::Commands::Registry.resolved_commands.reject { |name, _| name == 'help' }
      end

      def width
        @width ||= commands.keys.map(&:length).max.to_i
      end
    end
  end
end
