require 'spec_helper'

describe Rrod::Caster do
  let(:type)   { nil }
  let(:caster) { "#{described_class}::#{type}".constantize }

  describe "BigDecimal" do
    let(:type) { 'BigDecimal' } 
    it "converts to big decimal" do
      expect(caster.rrod_cast("42")).to eq 42
    end
  end

  describe "Boolean" do
    let(:type) { 'Boolean' }
    it "converts to true" do
      expect(caster.rrod_cast(true)).to be true
    end
    it "converts 'true' to true" do
      expect(caster.rrod_cast("true")).to be true
    end
    it "converts 1 to true" do
      expect(caster.rrod_cast(1)).to be true
    end
    it "converts '1' to true" do
      expect(caster.rrod_cast("1")).to be true
    end    
    it "converts to false" do
      expect(caster.rrod_cast(false)).to be false
    end
    it "converts 'false' to false" do
      expect(caster.rrod_cast("false")).to be false
    end
    it "converts 0 to false" do
      expect(caster.rrod_cast(0)).to be false
    end
    it "converts '0' to false" do
      expect(caster.rrod_cast("0")).to be false
    end    
    it "converts nil to false" do
      expect(caster.rrod_cast(nil)).to be false
    end    
    it "converts everything else to true" do
      expect(caster.rrod_cast(Object.new)).to be true
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
