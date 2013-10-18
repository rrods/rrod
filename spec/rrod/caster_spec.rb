require 'spec_helper'

describe Rrod::Caster do
  let(:type)   { nil }
  let(:caster) { "#{described_class}::#{type}".constantize }

  describe "casting instances" do
    it "is pretty fancy"
  end

  describe "BigDecimal" do
    let(:type) { 'BigDecimal' } 
    it "converts to big decimal" do
      expect(caster.rrod_cast("42")).to eq 42
    end
  end

  describe "Date" do
    let(:type) { 'Date' }
    let(:date) { Date.parse("2013-10-31") }
    it "converts db format to date" do
      expect(caster.rrod_cast("2013-10-31")).to eq date
    end
    it "converts standard format to date" do
      expect(caster.rrod_cast("31-10-2013")).to eq date
    end
    it "converts american format to date" do
      expect(caster.rrod_cast("10/31/2013")).to eq date
    end
  end

  describe "DateTime" do
    let(:type) { 'DateTime' }
    let(:datetime) { "12:13:14".to_datetime }
    it "converts time to datetime" do
      expect(caster.rrod_cast("12:13:14")).to eq datetime
    end
  end

  describe "Float" do
    let(:type)    { 'Float' }
    let(:floater) { 3.142 }
    it "converts to floating point" do
      expect(caster.rrod_cast("3.142")).to eq floater
    end
  end

  describe "Integer" do
    let(:type) { 'Integer' }
    it "converts to integer" do
      expect(caster.rrod_cast('4')).to eq 4
    end
  end

  describe "Numeric" do
    let(:type)    { 'Numeric' }
    it "converts to floating point" do
      expect(caster.rrod_cast("3.142")).to eq 3.142
    end
    it "converts to integer" do
      expect(caster.rrod_cast("3")).to eq 3
    end
  end

  describe "String" do
    let(:type) { 'String' }
    it "converts to string" do
      expect(caster.rrod_cast(:string)).to eq 'string'
    end
  end

  describe "Symbol" do
    let(:type) { 'Symbol' }
    it "converts to symbol" do
      expect(caster.rrod_cast('symbol')).to eq :symbol
    end
  end
   
  describe "Time" do
    let(:type) { 'Time' }
    let(:time) { "12:13:14".to_time }
    it "converts to time" do
      expect(caster.rrod_cast("12:13:14")).to eq time
    end
  end
end
