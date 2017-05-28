# frozen_string_literal: true

require "spec_helper"
require "support/wait_barrier"

RSpec.describe "Case: Cache stampede", :case do
  let(:store) { Macache::Stores::Memory.new }

  let(:cache) { Macache::Cache.new(store: store) }

  specify "Bla" do
    cache.set("my_key", "My orignal value", expires_in: 0.1)
    sleep(0.1)

    barrier = WaitBarrier.new

    thread =
      Thread.new do
        expect(
          cache.fetch("my_key", expires_in: 5, race_condition_ttl: 2) do
            barrier.wait
            "My generated value"
          end
        ).to eq("My generated value")
      end

    sleep(0.01) # make the thread runs

    expect(
      cache.fetch("my_key", expires_in: 5, race_condition_ttl: 2) do
        "My other generated value"
      end
    ).to eq("My orignal value")

    barrier.unlock
    thread.join

    expect(
      cache.fetch("my_key", expires_in: 5, race_condition_ttl: 2) do
        "My other generated value"
      end
    ).to eq("My generated value")
  end
end
