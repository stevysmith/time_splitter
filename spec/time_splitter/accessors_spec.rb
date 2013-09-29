require 'active_support/all'
require_relative "../../lib/time_splitter/accessors.rb"

describe TimeSplitter::Accessors do
  let(:model) { Model.new }
  before do
    class ModelParent; attr_accessor :starts_at; end
    class Model < ModelParent; attr_accessor :starts_at; end
    Model.extend(TimeSplitter::Accessors)
    Model.split_accessor(:starts_at)
  end

  describe "#starts_at" do
    it 'does not override the default reader for the field' do
      class Model; def starts_at; 5; end; end
      expect(model.starts_at).to eq 5
    end

    it 'correctly returns nil if not set' do
      expect(model.starts_at).to eq nil
    end
  end

  describe "split datetime methods" do
    context 'when #starts_at is nil' do
      describe "#starts_at_date" do
        it "returns nil" do
          expect(model.starts_at_date).to be_nil
        end

        it "lets you modify the format" do
          Model.split_accessor(:starts_at, format: "%D")
          expect(model.starts_at_date).to be_nil
        end

        it "sets the appropiate parts of #starts_at" do
          model.starts_at_date = Time.new(1111, 1, 1)
          expect(model.starts_at).to eq Time.new(1111, 1, 1, 0, 0, 0)
        end

        it "can set from a string" do
          model.starts_at_date = "1111-01-01"
          expect(model.starts_at).to eq Time.new(1111, 1, 1, 0, 0, 0)
        end

        it "is nil if the string is empty" do
          model.starts_at_date = ""
          expect(model.starts_at).to be_nil
        end
      end

      describe "#starts_at_hour" do
        it "returns nil" do
          expect(model.starts_at_hour).to be_nil
        end

        it "sets the hour of starts_at" do
          model.starts_at_hour = 11
          expect(model.starts_at).to eq Time.new(0, 1, 1, 11, 0, 0)
        end

        it "is nil if the string is empty" do
          model.starts_at_hour = ""
          expect(model.starts_at).to be_nil
        end
      end

      describe "#starts_at_min" do
        it "returns nil" do
          expect(model.starts_at_min).to be_nil
        end

        it "sets the minute of #starts_at" do
          model.starts_at_min = 55
          expect(model.starts_at).to eq Time.new(0, 1, 1, 0, 55, 0)
        end

        it "is nil if the string is empty" do
          model.starts_at_min = ""
          expect(model.starts_at).to be_nil
        end
      end

      describe '#starts_at_time' do
        it 'returns nil' do
          expect(model.starts_at_time).to be_nil
        end

        it 'sets the hour and minute of #starts_at' do
          model.starts_at_time = '08:33'
          expect(model.starts_at).to eq Time.new(0, 1, 1, 8, 33, 0)
        end

        it 'is nil if the string is empty' do
          model.starts_at_time = ''
          expect(model.starts_at).to be_nil
        end
      end
    end

    context 'when modifying #starts_at' do
      before { model.starts_at = Time.new(2222, 12, 22, 13, 44, 0) }

      describe "#starts_at_date" do
        it "returns the model's starts_at date as string" do
          expect(model.starts_at_date).to eq "2222-12-22"
        end

        it "lets you modify the format" do
          Model.split_accessor(:starts_at, format: "%D")
          expect(model.starts_at_date).to eq "12/22/22"
        end

        it "sets the appropiate parts of #starts_at" do
          model.starts_at_date = Time.new(1111, 1, 1)
          expect(model.starts_at).to eq Time.new(1111, 1, 1, 13, 44, 0)
        end

        it "can set from a string" do
          model.starts_at_date = "1111-01-01"
          expect(model.starts_at).to eq Time.new(1111, 1, 1, 13, 44, 0)
        end

        it "uses the default if the string is empty" do
          model.starts_at_date = ""
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 13, 44, 0)
        end
      end

      describe "#starts_at_hour" do
        it "returns the hour" do
          expect(model.starts_at_hour).to eq 13
        end

        it "sets the hour of starts_at" do
          model.starts_at_hour = 11
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 11, 44, 0)
        end

        it "uses the default if the string is empty" do
          model.starts_at_hour = ""
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 13, 44, 0)
        end
      end

      describe "#starts_at_min" do
        it "returns the min" do
          expect(model.starts_at_min).to eq 44
        end

        it "sets the minute of #starts_at" do
          model.starts_at_min = 55
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 13, 55, 0)
        end

        it "uses the default if the string is empty" do
          model.starts_at_min = ""
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 13, 44, 0)
        end
      end

      describe '#starts_at_time' do
        it 'returns the time' do
          expect(model.starts_at_time).to eq Time.new(2222, 12, 22, 13, 44, 0)
        end

        it 'sets the hour and minute of #starts_at' do
          model.starts_at_time = '08:33'
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 8, 33, 0)
        end

        it 'uses the default if the string is empty' do
          model.starts_at_time = ''
          expect(model.starts_at).to eq Time.new(2222, 12, 22, 13, 44, 0)
        end
      end
    end
  end
end
