# frozen_string_literal: true

module Macache
  class Cache

    def initialize(store:)
      @store = store
    end

    attr_reader :store

    def clear
      store.clear
    end

    def delete(key)
      store.delete(key)
    end

    def fetch(key, expires_in: nil)
      entry = store.read(key)
      return entry.value if entry && entry.value

      value = yield(key)

      entry = Entry.new(key, value, expires_in: expires_in)
      store.write(key, entry)

      value
    end

    def get(key)
      entry = store.read(key)

      entry && entry.value
    end

    def set(key, value, expires_in: nil)
      entry = Entry.new(key, value, expires_in: expires_in)

      store.write(key, entry)
    end

  end
end
