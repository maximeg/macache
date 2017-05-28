# frozen_string_literal: true

require "spec_helper"

RSpec.describe Macache::Stores::Null do
  subject { described_class.new }

  describe "#read" do
    it "returns nil, always" do
      expect(subject.read("my_key")).to eq(nil)
    end
  end
end
