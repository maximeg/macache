# frozen_string_literal: true

require "spec_helper"

RSpec.describe Macache::Stores::Memory do
  subject { described_class.new }

  describe "#clear" do
    context "when entry does exist in store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { subject.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.clear
        }.to change(subject, :data).from({ "my_key" => existing_entry }).to({})
      end
    end

    context "when entry does not exist in store" do
      it "does nothing" do
        expect {
          subject.clear
        }.not_to change(subject, :data).from({})
      end
    end
  end

  describe "#delete" do
    context "when entry does exist in store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { subject.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.delete("my_key")
        }.to change(subject, :data).from({ "my_key" => existing_entry }).to({})
      end
    end

    context "when entry does not exist in store" do
      it "does nothing" do
        expect {
          subject.delete("my_key")
        }.not_to change(subject, :data).from({})
      end
    end
  end

  describe "#read" do
    context "when entry does exist in store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { subject.write("my_key", existing_entry) }

      it "returns the entry" do
        expect(subject.read("my_key")).to eq(existing_entry)
      end
    end

    context "when entry does not exist in store" do
      it "returns nil" do
        expect(subject.read("my_key")).to eq(nil)
      end
    end
  end

  describe "#write" do
    let(:entry) { ::Macache::Entry.new("my_key", "my value") }

    context "when entry does exist in store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my old value") }

      before { subject.write("my_key", existing_entry) }

      it "overwrites the entry to the store" do
        expect {
          subject.write("my_key", entry)
        }.to change(subject, :data).from({ "my_key" => existing_entry }).to({ "my_key" => entry })
      end
    end

    context "when entry does not exist in store" do
      it "writes the entry to the store" do
        expect {
          subject.write("my_key", entry)
        }.to change(subject, :data).from({}).to({ "my_key" => entry })
      end
    end
  end
end
