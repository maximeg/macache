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

  end
end
