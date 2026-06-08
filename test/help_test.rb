require 'test_helper'
require 'tick_git_boom'

module TickGitBoom
  class HelpTest < Minitest::Test
    # Every registered command must appear in the overview, so a new command
    # cannot be added and silently left out of the help.
    def test_help_lists_every_registered_command
      out, = capture_io { Commands::Help.call([], 'help') }
      Commands::Registry.command_names.each do |name|
        assert_includes out, name, "#{name} missing from help"
      end
    end

    def test_command_help_flag_exits_cleanly
      out, = capture_io { Commands::Show.call(['--help'], 'show') }
      assert_includes out, 'Usage:'
      assert_includes out, 'tickgitboom show'
    end
  end
end
