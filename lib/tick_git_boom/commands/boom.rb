require 'tick_git_boom'

module TickGitBoom
  module Commands
    class Boom < TickGitBoom::Command
      class Opts < CLI::Kit::Opts
        include TickGitBoom::FormatOpts
      end

      desc 'Reset the runtime tickets file from the seed'
      long_desc 'Discards every local ticket change. The command name is the confirmation.'
      usage '[--format auto|table|json]'

      def invoke(op, _name)
        path = TicketStore.new.reset
        TicketOutput.notice(
          { 'reset' => true, 'path' => path },
          format: op.output_format,
          message: "Boom. Replaced {{bold:#{path}}}.\nAll local ticket changes were reset.",
        )
      end
    end
  end
end
