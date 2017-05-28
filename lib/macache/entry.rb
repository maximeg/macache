# frozen_string_literal: true

module Macache
  class Entry

    def initialize(key, value, expires_in: nil, version: nil)
      @key = key
      @value = value
      @version = version
      @expires_in = expires_in.to_f if expires_in
      @created_at = Time.now.to_f
    end

    attr_reader :created_at, :expires_in, :key, :value, :version

    def ==(other)
      return true if equal?(other)

      case other
      when Macache::Entry
        value == other.value
      when String
        value == other
      else
        false
      end
    end

    def eql?(other)
      return true if equal?(other)
      return false unless other.is_a?(Macache::Entry)

      key == other.key && value == other.value && version == other.version
    end

    def expired?
      return false unless entry.expires_in

      entry.created_at + entry.expires_in <= Time.now
    end

  end
end
