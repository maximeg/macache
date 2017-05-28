# frozen_string_literal: true

module Macache
  module Stores
    class Null < Base

      def clear
        nil
      end

      def delete(key) # rubocop:disable UnusedMethodArgument
        nil
      end

      def read(key) # rubocop:disable UnusedMethodArgument
        nil
      end

      def write(key, entry) # rubocop:disable UnusedMethodArgument
        nil
      end

    end
  end
end
