require 'spec_helper'
require 'support/models/car'

describe Rrod::Model do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  describe "instantiation" do
    it "can create an object with an arbitrary hash" do
      expect(instance.wheels).to eq 4
      expect(instance.color).to eq :black
      expect(instance.make).to eq 'Jeep'
    end

    it "always has an id property" do
      expect(instance).to respond_to :id
      expect(instance.id).to be_nil
    end

    it "manages attribute keys as strings" do
      expect(instance.attributes).to eq hash.stringify_keys
    end

    it "ignores modifications to the attribute hash" do
      instance.attributes[:model] = 'Wrangler'
      expect(instance.attributes[:model]).to be_nil
    end

    it "will return nil for an attribute that exists in the hash but does not have a corresponding method" do
      instance.instance_variable_get(:@attributes)['foo'] = 'bar'
      expect(instance).not_to respond_to(:foo)
      expect(instance.attributes).to include('foo' => nil)
    end

    describe "mass assignment" do
      it "will merge attributes when mass assigning" do
        instance.attributes = {wheels: 5}
        expect(instance.wheels).to eq 5
      end

      it "will not add additional attribute methods after instantiation" do
        expect { instance.attributes = {model: 'Wrangler'} }.to raise_error
      end
    end

    describe "with schema" do
      let(:model) { Class.new(Car) { attribute :wheels, Integer } }

      it "does not allow creating with arbitrary attributes" do
        expect { model.new(model: 'Jeep') }.to raise_error
      end

      it "can be created with the specified attributes" do
        expect(model.new(wheels: 5).wheels).to be 5
      end
    end

    describe "query generation" do
      it "lets you use strings with apostrophes in them" 
    end
  end
end
