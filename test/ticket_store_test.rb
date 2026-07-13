require 'test_helper'
require 'tick_git_boom'

module TickGitBoom
  class TicketStoreTest < Minitest::Test
    def setup
      @dir = Dir.mktmpdir
      @path = File.join(@dir, 'data', 'tickets.json')
    end

    def teardown
      FileUtils.rm_rf(@dir)
    end

    def store
      TicketStore.new(path: @path)
    end

    def test_bootstrap_copies_seed
      seeded = JSON.parse(File.read(SEED_PATH))['tickets'].size
      assert_equal seeded, store.tickets.size
      assert_equal File.read(SEED_PATH), File.read(@path)
    end

    def test_bootstrap_never_overwrites_existing_runtime_file
      s = store
      s.find('ZEN-001').close
      s.save

      assert_equal 'closed', store.find('ZEN-001').status
    end

    def test_save_round_trips_changes
      s = store
      s.find('zen-002').assignee = '  Claude Navier  '
      s.find('ZEN-002').add_comment(author: 'George Stokes', body: 'Noted.')
      s.save

      reloaded = store.find('ZEN-002')
      assert_equal 'Claude Navier', reloaded.assignee
      assert_equal ['George Stokes', 'Noted.'], reloaded.comments.last.values_at('author', 'body')
    end

    def test_reset_discards_runtime_changes
      s = store
      s.find('ZEN-001').close
      s.save

      store.reset
      assert_equal 'open', store.find('ZEN-001').status
    end

    def test_unknown_id_and_bad_status_abort
      assert_raises(CLI::Kit::Abort) { store.find('ZEN-999') }
      assert_raises(CLI::Kit::Abort) { store.find('ZEN-001').status = 'escalated' }
      assert_raises(CLI::Kit::Abort) { store.find('ZEN-001').assignee = '  ' }
      assert_raises(CLI::Kit::Abort) { store.find('ZEN-001').add_comment(author: 'x', body: '') }
    end

    def test_create_continues_the_id_sequence_and_defaults_to_open
      s = store
      highest = s.tickets.map { |t| t.id[/\d+\z/].to_i }.max

      ticket = s.create(subject: 'Kettle reports laminar flow', priority: 'high', requester: 'Ada', tags: ['queue'])
      s.save

      assert_equal format('ZEN-%03d', highest + 1), ticket.id
      assert_equal 'open', ticket.status
      assert_nil ticket.assignee
      assert_equal [], ticket.comments
      assert_equal ticket.id, store.tickets.last.id
    end

    def test_create_on_an_empty_file_starts_at_001
      store # bootstrap, so the data directory exists
      File.write(@path, JSON.generate('tickets' => []))
      assert_equal 'ZEN-001', store.create(subject: 'First', priority: 'low', requester: 'Ada', tags: []).id
    end
  end
end
