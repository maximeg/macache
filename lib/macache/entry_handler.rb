# frozen_string_literal: true

module Macache
  class EntryHandler

    def initialize(entry)
      @entry = entry
    end

    attr_reader :entry

    def expired?
      return false unless entry.expires_in

      entry.created_at + entry.expires_in <= Time.now
    end

  end
end
