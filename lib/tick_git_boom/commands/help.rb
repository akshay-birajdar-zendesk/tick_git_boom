require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Help < TickGitBoom::Command
      SUMMARY = 'A small local support-ticket CLI for the Git scavenger hunt.'.freeze

      # Commands grouped for the overview. Anything registered but not listed
      # here still shows up, under "Other commands".
      GROUPS = {
        'Read tickets' => %w[list show search],
        'Change tickets' => %w[create assign comment close],
        'Start over' => %w[boom],
      }.freeze

      EXAMPLES = [
        ['list', 'every ticket, as a table in a terminal'],
        ['list | jq -r \'.[].id\'', 'JSON automatically when piped'],
        ['show ZEN-001', 'one ticket with its comments'],
        ['search "queue"', 'match ticket subjects'],
        ['assign ZEN-001 "George Stokes"', 'reassign a ticket'],
        ['close ZEN-001 --format json', 'close and print the JSON result'],
        ['boom', 'reset every local ticket change'],
      ].freeze

      desc 'Show this help'

      def call(_args, _name)
        tool = TickGitBoom::TOOL_NAME

        puts CLI::UI.fmt("{{bold:#{tool}}} — #{SUMMARY}")
        puts ''
        puts CLI::UI.fmt('{{bold:Usage:}}')
        puts CLI::UI.fmt("  {{command:#{tool}}} {{yellow:COMMAND}} [ARGS] [--format auto|table|json]")
        puts ''

        grouped.each do |group, group_commands|
          puts CLI::UI.fmt("{{bold:#{group}:}}")
          group_commands.each do |name, klass|
            puts CLI::UI.fmt("  {{command:#{name.ljust(width)}}}  #{klass._desc}")
          end
          puts ''
        end

        puts CLI::UI.fmt('{{bold:Examples:}}')
        example_width = EXAMPLES.map { |args, _| args.length }.max
        EXAMPLES.each do |args, explanation|
          puts CLI::UI.fmt("  {{command:#{tool} #{args.ljust(example_width)}}}  {{italic:{{gray:# #{explanation}}}}}")
        end
        puts ''

        puts CLI::UI.fmt('{{bold:Output:}} {{italic:auto}} uses a table on a terminal and JSON when piped or ' \
          'redirected. Pass {{italic:--format json}} or {{italic:--format table}} to be explicit.')
        puts ''
        puts CLI::UI.fmt("Run {{command:#{tool} COMMAND --help}} for that command's usage, options, and examples.")
      end

      private

      def commands
        @commands ||= TickGitBoom::Commands::Registry.resolved_commands.reject { |name, _| name == 'help' }
      end

      def width
        @width ||= commands.keys.map(&:length).max.to_i
      end

      # { group => [[name, klass], ...] } in GROUPS order, ungrouped commands last.
      def grouped
        seen = GROUPS.values.flatten
        groups = GROUPS.to_h do |group, names|
          [group, names.filter_map { |name| [name, commands[name]] if commands.key?(name) }]
        end
        leftovers = commands.reject { |name, _| seen.include?(name) }.to_a
        groups['Other commands'] = leftovers if leftovers.any?
        groups.reject { |_, cmds| cmds.empty? }
      end
    end
  end
end
