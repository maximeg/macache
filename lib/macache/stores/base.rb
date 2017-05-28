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

    end
  end
end
