# frozen_string_literal: true

module Macache
  class Cache

    def initialize(store)
      @store = store
    end

    attr_reader :store

    def fetch(key)
      value = get(key)
      return value if value

      value = yield
      set(key, value)

      value
    end

    def get(key)
      entry = store.read(key)

      entry && entry.value
    end

    def set(key, value)
      entry = Entry.new(key, value)

      store.write(key, entry)
    end

  end
end
