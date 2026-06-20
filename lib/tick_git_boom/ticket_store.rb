require 'tick_git_boom'
require 'json'
require 'fileutils'

module TickGitBoom
  # Owns the runtime JSON file: load and find tickets.
  class TicketStore
    DEFAULT_PREFIX = 'ZEN-'

    attr_reader :path

    def initialize(path: TickGitBoom::DATA_PATH, seed_path: TickGitBoom::SEED_PATH)
      @path = path
      @seed_path = seed_path
      copy_seed unless File.exist?(@path)
    end

    def tickets
      @tickets ||= begin
        doc = JSON.parse(File.read(@path))
        Array(doc['tickets']).map { |h| Ticket.from_h(h) }
      rescue JSON::ParserError => e
        raise(CLI::Kit::Abort, "#{@path} is not valid JSON: #{e.message}")
      end
    end

    def find(id)
      tickets.find { |t| t.id.casecmp?(id.to_s.strip) } ||
        raise(CLI::Kit::Abort, "no ticket with id #{id.inspect}")
    end

    def create(subject:, priority:, requester:, tags:)
      raise(CLI::Kit::Abort, 'subject cannot be blank') if subject.to_s.strip.empty?

      ticket = Ticket.from_h(
        'id' => next_id,
        'subject' => subject,
        'status' => 'open',
        'priority' => priority,
        'requester' => requester,
        'tags' => tags,
        'comments' => [],
      )
      tickets << ticket
      ticket
    end

    # Write to a temporary file and rename over the target, so a crash never
    # leaves a half-written document behind.
    def save
      tmp = "#{@path}.tmp"
      File.write(tmp, JSON.pretty_generate('tickets' => tickets.map(&:to_h)) + "\n")
      File.rename(tmp, @path)
      @path
    end

    # Discards every runtime change. The command name is the confirmation.
    def reset
      copy_seed
      @tickets = @next_number = @prefix = nil
      @path
    end

    private

    # Sequence state, read once from the loaded tickets and then carried in
    # memory, so several creates in one run keep counting up. The prefix comes
    # from the data, so a renamed prefix survives.
    def next_id
      @next_number ||= tickets.map { |t| t.id[/\d+\z/].to_i }.max.to_i
      @prefix ||= tickets.last&.id&.slice(/\A.*?(?=\d+\z)/) || DEFAULT_PREFIX
      format('%s%03d', @prefix, @next_number)
    end

    # Copy the tracked seed into place. Used to bootstrap the runtime file the
    # first time the tool runs; the caller guards against clobbering.
    def copy_seed
      FileUtils.mkdir_p(File.dirname(@path))
      FileUtils.cp(@seed_path, @path)
    end
  end
end
