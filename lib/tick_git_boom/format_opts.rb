require 'tick_git_boom'

module TickGitBoom
  # Shared `--format` option, included by each command's Opts class.
  # Named output_format, not format: cli-kit looks the value up with
  # `send(name)` on a lookup object where :format hits Kernel#format.
  module FormatOpts
    include CLI::Kit::Opts::Mixin

    def output_format
      option!(name: :output_format, long: '--format', desc: 'auto|table|json', default: 'auto')
    end
  end
end
