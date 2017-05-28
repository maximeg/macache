# frozen_string_literal: true

require "spec_helper"

RSpec.describe Macache::Cache do
  let(:store) { Macache::Stores::Memory.new }

  subject { described_class.new(store: store) }

  describe "#clear" do
    context "when entry exists in store" do
      let(:entry) { Macache::Entry.new("my_key", "my value") }

      before do
        store.write("my_key", entry)
      end

      it "returns the value of the entry" do
        expect {
          subject.clear
        }.to change { store.read("my_key") }.from(entry).to(nil)
      end
    end

    context "when entry does not exist in store" do
      it "returns nil" do
        expect {
          subject.clear
        }.not_to change { store.read("my_key") }.from(nil)
      end
    end
  end

  describe "#delete" do
    context "when entry exists in store" do
      let(:entry) { Macache::Entry.new("my_key", "my value") }

      before do
        store.write("my_key", entry)
      end

      it "returns the value of the entry" do
        expect {
          subject.delete("my_key")
        }.to change { store.read("my_key") }.from(entry).to(nil)
      end
    end

    context "when entry does not exist in store" do
      it "returns nil" do
        expect {
          subject.delete("my_key")
        }.not_to change { store.read("my_key") }.from(nil)
      end
    end
  end

  describe "#fetch" do
    context "when entry exists in store" do
      let(:entry) { Macache::Entry.new("my_key", "my cached value") }

      before do
        store.write("my_key", entry)
      end

      it "does not yield" do
        expect { |b|
          subject.fetch("my_key", &b)
        }.not_to yield_control
      end

      it "returns the value of the entry" do
        expect(
          subject.fetch("my_key") do
            "my calculated value"
          end
        ).to eq("my cached value")
      end

      it "does nothing in the store" do
        expect {
          subject.fetch("my_key") do
            "my calculated value"
          end
        }.not_to change { store.read("my_key") }.from(entry)
      end
    end

    context "when entry does not exist in store" do
      it "yields with the key as argument" do
        expect { |b|
          subject.fetch("my_key", &b)
        }.to yield_with_args("my_key")
      end

      it "returns the value of the block" do
        expect(
          subject.fetch("my_key") do
            "my calculated value"
          end
        ).to eq("my calculated value")
      end

      it "writes an entry in the store" do
        expect {
          subject.fetch("my_key") do
            "my calculated value"
          end
        }.to change { store.read("my_key") }.from(nil).to(Macache::Entry.new("my_key", "my calculated value"))
      end
    end
  end

  describe "#get" do
    context "when entry exists in store" do
      let(:entry) { Macache::Entry.new("my_key", "my value") }

      before do
        store.write("my_key", entry)
      end

      it "returns the value of the entry" do
        expect(subject.get("my_key")).to eq("my value")
      end
    end

    context "when entry does not exist in store" do
      it "returns nil" do
        expect(subject.get("my_key")).to eq(nil)
      end
    end
  end

  describe "#set" do
    context "when entry exists in store" do
      let(:entry) { Macache::Entry.new("my_key", "my old value") }

      before do
        store.write("my_key", entry)
      end

      it "overwrites the entry in the store" do
        expect {
          subject.set("my_key", "my new value")
        }.to change { store.read("my_key") }.from(entry).to(Macache::Entry.new("my_key", "my new value"))
      end
    end

    context "when entry does not exist in store" do
      it "writes an entry in the store" do
        expect {
          subject.set("my_key", "my value")
        }.to change { store.read("my_key") }.from(nil).to(Macache::Entry.new("my_key", "my value"))
      end
    end
  end
end
