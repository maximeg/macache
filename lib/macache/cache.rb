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

    def fetch(key, expires_in: nil, race_condition_ttl: nil)
      entry = store.read(key)

      return entry.value if entry && !entry.expired?

      if entry && entry.expired?
        if race_condition_ttl && Time.now.to_f <= entry.expires_at + race_condition_ttl
          entry.expires_at = Time.now + race_condition_ttl
          store.write(key, entry)
        end
      end

      value = yield(key)

      entry = Entry.new(key, value, expires_in: expires_in)
      store.write(key, entry)

      value
    end

    def get(key)
      entry = store.read(key)
      return nil unless entry

      if entry.expired?
        store.delete(key)
        return nil
      end

      entry.value
    end

    def set(key, value, expires_in: nil)
      entry = Entry.new(key, value, expires_in: expires_in)

      store.write(key, entry)
    end

  end
end
