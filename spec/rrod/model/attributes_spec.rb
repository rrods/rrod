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

    it "does not re-define an attribute for :id" do
      instance = model.new(id: 'Dogs are silly!')
      included_module = instance.attribute_methods
      expect(Class.new{extend included_module}).not_to respond_to :id 
    end
  end
end
