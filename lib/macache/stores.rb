# frozen_string_literal: true

module Macache
  module Stores

    class StoreError < ::RuntimeError

      attr_accessor :key

    end

    class CannotWriteError < StoreError
    end

    class CannotReadError < StoreError
    end

  end
end
