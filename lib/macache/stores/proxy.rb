# frozen_string_literal: true

module Macache
  module Stores
    class Proxy < Base

      def initialize(front_store, back_store)
        @front_store = front_store
        @back_store = back_store
      end

      attr_reader :front_store, :back_store

      def clear
        front_store.clear
        back_store.clear
      end

      def delete(key)
        front_store.delete(key)
        back_store.delete(key)
      end

      def read(key)
        front_entry = front_store.read(key)
        return front_entry if front_entry

        back_entry = back_store.read(key)
        front_store.write(key, back_entry) if back_entry

        back_entry
      end

      def write(key, entry)
        front_store.write(key, entry)
        back_store.write(key, entry)
      end

    end
  end
end
