require 'tick_git_boom'

module TickGitBoom
  # Base for every command. Exists only so `COMMAND --help` prints help and
  # exits 0: CLI::Kit parses required positions before it looks at the help
  # flag, so `tickgitboom show --help` would otherwise fail with
  # "more arguments required".
  class Command < CLI::Kit::BaseCommand
    HELP_FLAGS = ['--help', '-h'].freeze

    def call(args, name)
      if args.any? { |a| HELP_FLAGS.include?(a) }
        puts self.class.build_help
        return
      end

      super
    end
  end
end
