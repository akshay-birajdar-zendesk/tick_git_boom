require 'tick_git_boom'

module TickGitBoom
  # Shared `--format` option, included by each command's Opts class.
  module FormatOpts
    include CLI::Kit::Opts::Mixin

    def format
      option!(name: :format, long: '--format', desc: 'auto|table|json', default: 'auto')
    end
  end
end
