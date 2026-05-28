require 'tick_git_boom'

module TickGitBoom
  # A single support ticket. Mutations validate; everything else is data.
  class Ticket
    STATUSES = %w[open pending closed].freeze

    attr_reader :id, :subject, :priority, :requester, :tags, :comments, :status, :assignee

    def self.from_h(hash)
      h = hash.transform_keys(&:to_sym)
      %i[id subject status].each do |key|
        next unless h[key].to_s.strip.empty?

        raise(CLI::Kit::Abort, "ticket #{h[:id] || '(no id)'} is missing #{key}")
      end
      new(**h.slice(:id, :subject, :status, :priority, :requester, :assignee, :tags, :comments))
    end

    def initialize(id:, subject:, status:, priority: nil, requester: nil, assignee: nil, tags: [], comments: [])
      @id = id
      @subject = subject
      @priority = priority
      @requester = requester
      @assignee = assignee
      @tags = tags || []
      @comments = comments || []
      self.status = status
    end

    def status=(value)
      unless STATUSES.include?(value)
        raise(CLI::Kit::Abort, "unknown status #{value.inspect}; expected one of #{STATUSES.join(', ')}")
      end

      @status = value
    end

    def assignee=(name)
      raise(CLI::Kit::Abort, 'assignee cannot be blank') if name.to_s.strip.empty?

      @assignee = name.strip
    end

    def add_comment(author:, body:)
      raise(CLI::Kit::Abort, 'comment cannot be blank') if body.to_s.strip.empty?

      @comments << { 'author' => author, 'body' => body.strip }
    end

    def close
      self.status = 'closed'
    end

    # Subject only, by design: search is a demo, not a full-text index.
    def matches?(query)
      subject.downcase.include?(query.to_s.strip.downcase)
    end

    def to_h
      {
        'id' => id,
        'subject' => subject,
        'status' => status,
        'priority' => priority,
        'requester' => requester,
        'assignee' => assignee,
        'tags' => tags,
        'comments' => comments,
      }
    end
  end
end
