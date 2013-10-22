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

  it "will raise an error if it can't be found"

  it "is persisted" do
    found = model.find(instance.id)
    expect(found).to be_persisted
  end

  it "sets the robject on the found instance"

  describe "finding by attributes in the hash" do
    describe "find_first_by" do
      it "can find one" do
        found = model.find_first_by(make: 'Jeep')
        expect(found).to be_a model 
        expect(found.make).to eq "Jeep"
      end

      it "will work properly when finding by id"

      it "will return nil if one can't be found"

      it "will raise an exception if one can't be found with a !"
    end

    describe "find_all_by" do
      it "can find all" do
        founds = model.find_all_by(make: 'Jeep', wheels: 4)
        found = founds.first
        expect(founds).to be_an Array
        expect(found).to be_a model 
        expect(found.make).to eq "Jeep"
      end

      it "will work properly when finding all by id"

      it "will return [] if none can be found"

      it "will raise an exception if none can be found with a !"
    end
  end
end
