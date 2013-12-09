require 'spec_helper'

describe Rrod::Model::Timestamps do
  let(:klass)     { Class.new {include Rrod::Model; timestamps!} }
  let(:instance)  { klass.new }
  let(:attribute) { Rrod::Model::Attribute }
  let(:now)       { Time.now }

  it "provides a created_at attribute" do
    expect(klass.attributes[:created_at]).to be_an attribute
  end

  it "provides a updated_at attribute" do
    expect(klass.attributes[:updated_at]).to be_an attribute
  end

  describe "Time.now" do
    before(:each) { Time.stub(:now).and_return(now) }

    it "sets created_at upon instantiation" do
      expect(instance.created_at).to eq now
    end

    it "sets updated_at when the object is updated" do
      instance.stub(:persist).and_return(true)
      expect(instance).to receive(:updated_at=).with(now)
      instance.save
    end
  end
end
