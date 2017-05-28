# frozen_string_literal: true

module Macache
  module Stores
    class Base

      def clear
        raise NotImplementedError
      end

      def delete(key) # rubocop:disable UnusedMethodArgument
        raise NotImplementedError
      end

      def read(key) # rubocop:disable UnusedMethodArgument
        raise NotImplementedError
      end

      def write(key, entry) # rubocop:disable UnusedMethodArgument
        raise NotImplementedError
      end

      private

      def serialize(entry)
        entry
      end

      def deserialize(stored_entry)
        stored_entry
      end

    end
  end
end
