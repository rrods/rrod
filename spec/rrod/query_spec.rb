require 'spec_helper'

describe Rrod::Query do

  let(:options) { {} }
  let(:query)   { described_class.new(options) }

  describe "instantiation" do
    it "raises an error if no options are given" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it "raises an error if id is mixed with other options" do
      expect { described_class.new(id: 'foo', bar: 'baz') }.to raise_error(ArgumentError)
    end
  end

  describe "id" do
    let(:options) { {id: 'brains are yummy'} }

    it "exposes the id" do
      expect(query.id).to eq 'brains are yummy'
    end
  end

  describe "attributes" do
    let(:options) { {color: 'black', wheels: 5} }

    it "converts attributes to a search string" do
      expect(query.to_s).to eq "color:black AND wheels:5"
    end
  end

end
