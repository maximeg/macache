# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Macache::VERSION" do
  subject { Macache::VERSION }

  it "exists" do
    expect(subject).not_to be(nil)
  end

  it "has the right format" do
    expect(subject).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
