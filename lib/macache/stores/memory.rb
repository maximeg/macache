# frozen_string_literal: true

module Macache
  module Stores
    class Memory < Base

      def initialize
        @data = {}
      end

      attr_reader :data

      def clear
        @data.clear
      end

      def delete(key)
        @data.delete(key)
      end

      def read(key)
        stored_entry = @data[key]

        stored_entry && deserialize(stored_entry)
      end

      def write(key, entry)
        stored_entry = serialize(entry)

        @data[key] = stored_entry
      end

    end
  end
end
