# frozen_string_literal: true

require "spec_helper"

RSpec.describe Macache::Stores::Proxy do
  let(:front_store) { Macache::Stores::Memory.new }
  let(:back_store) { Macache::Stores::Memory.new }

  subject { described_class.new(front_store, back_store) }

  describe "#clear" do
    context "when entry does exist in front store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { front_store.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.clear
        }.to change { front_store.read("my_key") }.from(existing_entry).to(nil)
      end
    end

    context "when entry does not exist in back store" do
      it "does nothing" do
        expect {
          subject.clear
        }.not_to change { front_store.read("my_key") }.from(nil)
      end
    end

    context "when entry does exist in back store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { back_store.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.clear
        }.to change { back_store.read("my_key") }.from(existing_entry).to(nil)
      end
    end

    context "when entry does not exist in back store" do
      it "does nothing" do
        expect {
          subject.clear
        }.not_to change { back_store.read("my_key") }.from(nil)
      end
    end
  end

  describe "#delete" do
    context "when entry does exist in front store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { front_store.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.delete("my_key")
        }.to change { front_store.read("my_key") }.from(existing_entry).to(nil)
      end
    end

    context "when entry does not exist in back store" do
      it "does nothing" do
        expect {
          subject.delete("my_key")
        }.not_to change { front_store.read("my_key") }.from(nil)
      end
    end

    context "when entry does exist in back store" do
      let(:existing_entry) { ::Macache::Entry.new("my_key", "my value") }

      before { back_store.write("my_key", existing_entry) }

      it "deletes the entry" do
        expect {
          subject.delete("my_key")
        }.to change { back_store.read("my_key") }.from(existing_entry).to(nil)
      end
    end

    context "when entry does not exist in back store" do
      it "does nothing" do
        expect {
          subject.delete("my_key")
        }.not_to change { back_store.read("my_key") }.from(nil)
      end
    end
  end

  describe "#read" do
    context "when entry does exist in front store but not in back store" do
      let(:existing_front_entry) { ::Macache::Entry.new("my_key", "my value front") }

      before do
        front_store.write("my_key", existing_front_entry)
      end

      it "returns the entry from the front store" do
        expect(subject.read("my_key")).to eq(existing_front_entry)
      end

      it "does not write the entry to the back store" do
        expect {
          subject.read("my_key")
        }.not_to change { back_store.read("my_key") }.from(nil)
      end
    end

    context "when entry does exist in front store and in back store" do
      let(:existing_front_entry) { ::Macache::Entry.new("my_key", "my value front") }
      let(:existing_back_entry) { ::Macache::Entry.new("my_key", "my value back") }

      before do
        front_store.write("my_key", existing_front_entry)
        back_store.write("my_key", existing_back_entry)
      end

      it "returns the entry from the front store" do
        expect(subject.read("my_key")).to eq(existing_front_entry)
      end
    end

    context "when entry does exist in back store but not in front store" do
      let(:existing_back_entry) { ::Macache::Entry.new("my_key", "my value back") }

      before do
        back_store.write("my_key", existing_back_entry)
      end

      it "returns the entry from the back store" do
        expect(subject.read("my_key")).to eq(existing_back_entry)
      end

      it "writes the entry to the front store" do
        expect {
          subject.read("my_key")
        }.to change { front_store.read("my_key") }.from(nil).to(existing_back_entry)
      end
    end

    context "when entry does not exist in stores" do
      it "returns nil" do
        expect(subject.read("my_key")).to eq(nil)
      end
    end
  end

  describe "#write" do
    let(:entry) { ::Macache::Entry.new("my_key", "my value") }

    context "when entry does exist in front store but not in back store" do
      let(:existing_front_entry) { ::Macache::Entry.new("my_key", "my value front") }

      before do
        front_store.write("my_key", existing_front_entry)
      end

      it "writes the entry to the front store" do
        expect {
          subject.write("my_key", entry)
        }.to change { front_store.read("my_key") }.from(existing_front_entry).to(entry)
      end

      it "writes the entry to the back store" do
        expect {
          subject.write("my_key", entry)
        }.to change { back_store.read("my_key") }.from(nil).to(entry)
      end
    end

    context "when entry does exist in front store and in back store" do
      let(:existing_front_entry) { ::Macache::Entry.new("my_key", "my value front") }
      let(:existing_back_entry) { ::Macache::Entry.new("my_key", "my value back") }

      before do
        front_store.write("my_key", existing_front_entry)
        back_store.write("my_key", existing_back_entry)
      end

      it "writes the entry to the front store" do
        expect {
          subject.write("my_key", entry)
        }.to change { front_store.read("my_key") }.from(existing_front_entry).to(entry)
      end

      it "writes the entry to the back store" do
        expect {
          subject.write("my_key", entry)
        }.to change { back_store.read("my_key") }.from(existing_back_entry).to(entry)
      end
    end

    context "when entry does exist in back store but not in front store" do
      let(:existing_back_entry) { ::Macache::Entry.new("my_key", "my value back") }

      before do
        back_store.write("my_key", existing_back_entry)
      end

      it "writes the entry to the front store" do
        expect {
          subject.write("my_key", entry)
        }.to change { front_store.read("my_key") }.from(nil).to(entry)
      end

      it "writes the entry to the back store" do
        expect {
          subject.write("my_key", entry)
        }.to change { back_store.read("my_key") }.from(existing_back_entry).to(entry)
      end
    end

    context "when entry does not exist in stores" do
      it "writes the entry to the front store" do
        expect {
          subject.write("my_key", entry)
        }.to change { front_store.read("my_key") }.from(nil).to(entry)
      end

      it "writes the entry to the back store" do
        expect {
          subject.write("my_key", entry)
        }.to change { back_store.read("my_key") }.from(nil).to(entry)
      end
    end
  end
end
