require 'tick_git_boom'
require 'json'

module TickGitBoom
  # Owns the runtime JSON file: load and find tickets.
  class TicketStore
    attr_reader :path

    def initialize(path: TickGitBoom::DATA_PATH, seed_path: TickGitBoom::SEED_PATH)
      @path = path
      @seed_path = seed_path
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

    # Write to a temporary file and rename over the target, so a crash never
    # leaves a half-written document behind.
    def save
      tmp = "#{@path}.tmp"
      File.write(tmp, JSON.pretty_generate('tickets' => tickets.map(&:to_h)) + "\n")
      File.rename(tmp, @path)
      @path
    end
  end
end
