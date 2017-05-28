# frozen_string_literal: true

module Macache
  class Entry

    def initialize(key, value, created_at: nil, expires_in: nil, version: nil)
      @key = key
      @value = value

      @created_at = (created_at || Time.now).to_f
      @expires_in = expires_in.to_f if expires_in
      @version = version
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
      return false unless expires_in

      created_at + expires_in <= Time.now.to_f
    end

    def expires_at
      return nil unless expires_in

      created_at + expires_in
    end

    def expires_at=(value)
      @expires_in = value ? value.to_f - created_at : nil
    end

  end
end
