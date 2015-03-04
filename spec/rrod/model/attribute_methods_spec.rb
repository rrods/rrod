require 'spec_helper'
require 'support/models/car'

describe Rrod::Model do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  describe "instantiation" do
    it "can create an object with an arbitrary hash" do
      expect(instance.wheels).to eq 4
      # @TODO expect(instance.color).to eq :black
      expect(instance.make).to eq 'Jeep'
    end

    it "is not dirty when created" do
      expect(instance).not_to be_changed
    end

    it "always has an id property" do
      expect(instance).to respond_to :id
      expect(instance.id).to be_nil
    end

    it "includes the id property in the attributes hash" do
      instance.save
      expect(instance.attributes.keys).to include('id')
    end

    describe "nested models" do
      let(:model)  { BatMobile }
      let(:hash)   { {weapons: [{type: 'Rocket', damage: 12_345}]} }
      let(:nested) { instance.weapons.first }

      it "has a nil id" do
        expect(nested.id).to be_nil
      end

      it "excludes id from attributes" do
        expect(nested.attributes.keys).not_to include('id')
      end
    end

    it "manages attribute keys as strings" do
      expect(instance.attributes.keys.sort).to eq hash.stringify_keys.keys.push('id').sort
    end

    it "ignores modifications to the attribute hash" do
      instance.attributes[:model] = 'Wrangler'
      expect(instance.attributes[:model]).to be_nil
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
      # let(:model) { Class.new(Car) { attribute :wheels, Integer } }
      # let(:model) { Car }
      let(:model) { Class.new(Car) }

      it "does not allow creating with arbitrary attributes" do
        expect { model.new(model: 'Jeep') }.to raise_error(NoMethodError, /model=/)
      end

      it "can be created with the specified attributes" do
        expect(model.new(wheels: 5).wheels).to be 5
      end
    end

  end

  describe "defaults" do
    let(:model)    { Class.new(Car) { attribute :wheels, Integer, default: 4 } }
    let(:instance) { model.new }

    it "will return the default when reading a nil value" do
      expect(instance.wheels).to eq 4
    end

    it "will set the default to the read value" do
      instance.wheels
      expect(instance.instance_variable_get(:@attributes)['wheels']).to eq 4
    end
  end

  describe "dirty tracking" do
    let(:model)    { Class.new(Car) { attribute :wheels, Integer, default: 4 } }
    let(:instance) { model.new(make: 'Jeep') }

    it "will track if an attribute is changing" do
      instance.wheels = 5
      expect(instance.wheels_changed?).to be true
    end

    it "will not track if an attribute is set from a default" do
      expect(instance.wheels).to eq 4
      expect(instance.wheels_changed?).to be false
    end

    it "will not track if an attribute has not changed" do
      instance.make = 'Jeep'
      expect(instance.wheels_changed?).to be false
    end
  end
end
