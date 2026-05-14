require 'test_helper'
require 'tick_git_boom'
require 'json'

module TickGitBoom
  class TicketOutputTest < Minitest::Test
    def ticket
      Ticket.from_h('id' => 'ZEN-001', 'subject' => 'Queue velocity appears turbulent', 'status' => 'open')
    end

    def test_auto_uses_json_when_stdout_is_not_a_tty
      assert_equal :json, TicketOutput.resolve('auto')
      assert_equal :table, TicketOutput.resolve('table')
    end

    def test_unknown_format_aborts
      assert_raises(CLI::Kit::Abort) { TicketOutput.resolve('yaml') }
    end

    def test_json_output_is_parseable
      out, = capture_io { TicketOutput.list([ticket], format: 'json') }
      assert_equal ['ZEN-001'], JSON.parse(out).map { |t| t['id'] }

      out, = capture_io { TicketOutput.show(ticket, format: 'json', message: 'ignored in json') }
      assert_equal 'open', JSON.parse(out)['status']
    end

    def test_table_show_wraps_long_comments_within_the_terminal
      long = Ticket.from_h(
        'id' => 'ZEN-001',
        'subject' => 'Queue velocity appears turbulent',
        'status' => 'open',
        'comments' => [{ 'author' => 'Claude Navier', 'body' => 'turbulent ' * 40 }],
      )

      out, = capture_io { TicketOutput.show(long, format: 'table') }
      body_lines = out.lines.grep(/turbulent/).map(&:chomp)

      assert_operator body_lines.size, :>, 1, 'expected the comment to wrap'
      body_lines.each do |line|
        plain = line.gsub(/\e\[[0-9;]*m/, '')
        assert_operator plain.length, :<=, CLI::UI::Terminal.width, "line too wide: #{plain.inspect}"
        assert_match(/^\s*\S/, plain)
      end
    end
  end
end
