require 'spec_helper'
require 'support/models/car'

describe Rrod::Model::Finders, integration: true do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  before :each do
    instance.save
  end

  it "can be found by id" do
    found = model.find(instance.id)
    expect(found).to be_a model
  end

  describe "finding by attributes in the hash" do
    it "can find one" do
      found = model.find_by(make: 'Jeep')
      expect(found).to be_a model 
      expect(found.make).to eq "Jeep"
    end

    it "can find all" do
      founds = model.find_all_by(make: 'Jeep', wheels: 4)
      found = founds.first
      expect(founds).to be_an Array
      expect(found).to be_a model 
      expect(found.make).to eq "Jeep"
    end
  end
end
