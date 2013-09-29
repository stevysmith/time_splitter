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
    it "lets the superclass (usually ActiveRecord::Base) override the value" do
      class ModelParent; def starts_at; 5; end; end
      model.starts_at.should == 5
    end
  end

  describe "split datetime methods" do
    before { model.starts_at = Time.new(2222, 12, 22, 13, 44, 0) }

    describe "#starts_at_date" do
      it "returns the model's starts_at date as string" do
        model.starts_at_date.should == "2222-12-22"
      end

      it "lets you modify the format" do
        Model.split_accessor(:starts_at, format: "%D")
        model.starts_at_date.should == "12/22/22"
      end

      it "sets the appropiate parts of #starts_at" do
        model.starts_at_date = Time.new(1111, 1, 1)
        model.starts_at.should == Time.new(1111, 1, 1, 13, 44, 0)
      end

      it "can set from a string" do
        model.starts_at_date = "1111-01-01"
        model.starts_at.should == Time.new(1111, 1, 1, 13, 44, 0)
      end

      it "uses the default if the string is empty" do
        model.starts_at_date = ""
        model.starts_at.should == Time.new(2222, 12, 22, 13, 44, 0)
      end
    end

    describe "#starts_at_hour" do
      it "returns the hour" do
        model.starts_at_hour.should == 13
      end

      it "sets the hour of starts_at" do
        model.starts_at_hour = 11
        model.starts_at.should == Time.new(2222, 12, 22, 11, 44, 0)
      end

      it "uses the default if the string is empty" do
        model.starts_at_hour = ""
        model.starts_at.should == Time.new(2222, 12, 22, 13, 44, 0)
      end
    end

    describe "#starts_at_min" do
      it "returns the min" do
        model.starts_at_min.should == 44
      end

      it "sets the minute of #starts_at" do
        model.starts_at_min = 55
        model.starts_at.should == Time.new(2222, 12, 22, 13, 55, 0)
      end

      it "uses the default if the string is empty" do
        model.starts_at_min = ""
        model.starts_at.should == Time.new(2222, 12, 22, 13, 44, 0)
      end
    end

    describe '#starts_at_time' do
      it 'returns the time' do
        model.starts_at_time.should == Time.new(2222, 12, 22, 13, 44, 0)
      end

      it 'sets the hour and minute of #starts_at' do
        model.starts_at_time = '08:33'
        model.starts_at.should == Time.new(2222, 12, 22, 8, 33, 0)
      end

      it 'uses the default if the string is empty' do
        model.starts_at_time = ''
        model.starts_at.should == Time.new(2222, 12, 22, 13, 44, 0)
      end
    end
  end
end
