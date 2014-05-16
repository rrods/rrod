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

  it "will raise an error if it can't be found" do
    expect { model.find("id that is not there") }.to raise_error(Rrod::Model::NotFound)
  end

  it "is persisted" do
    found = model.find(instance.id)
    expect(found).to be_persisted
  end

  it "sets the robject on the found instance" do
    found = model.find(instance.id)
    expect(found.robject).to be_a Riak::RObject
  end

  describe "finding by attributes in the hash" do
    describe "find_by" do
      it "can find one" do
        found = model.find_by(make: 'Jeep')
        expect(found).to be_a model 
        expect(found.make).to eq "Jeep"
      end

      it "will work properly when finding by id" do
        found = model.find_by(id: instance.id)
        expect(found).to be_a model
      end

      it "will return nil if one can't be found" do
        found = model.find_by(id: "id that is not there")
        expect(found).to be nil
      end

      it "will raise an exception if one can't be found with a !" do
        expect { model.find_by! zombies: true }.to raise_error(Rrod::Model::NotFound)
      end
    end

    describe "search" do
      it "can find all" do
        founds = model.search(make: 'Jeep', wheels: 4)
        found = founds.first
        expect(founds).to be_an Array
        expect(found).to be_a model 
        expect(found.make).to eq "Jeep"
      end

      it "will raise an exception if searching by id" do
        expect {model.search(id: instance.id)}.to raise_error(ArgumentError)
      end

      it "will return [] if none can be found" do
        expect(model.search zombies: 'yes plz').to eq []
      end

      it "will raise an exception if none can be found with a !" do
        expect { model.search! brains: :none }.to raise_error(Rrod::Model::NotFound)
      end
    end
  end

end
