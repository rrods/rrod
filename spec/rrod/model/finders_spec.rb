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

  it "will have the id of the key it is found with" do
    found = model.find(instance.id)
    expect(found.id).to eq instance.id
  end

  it "will raise an error if it can't be found" do
    expect { model.find("id that is not there") }.to raise_error(Rrod::Model::NotFound)
  end

  describe "when finding" do
    let(:found) { model.find(instance.id) }

    it "is persisted" do
      expect(found).to be_persisted
    end

    it "is not changed" do
      expect(found).not_to be_changed
    end

    it "sets the robject on the found instance" do
      expect(found.robject).to be_a Riak::RObject
    end
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
        founds = model.find_all_by(make: 'Jeep', wheels: 4)
        found = founds.first
        expect(founds).to be_an Array
        expect(found).to be_a model 
        expect(found.make).to eq "Jeep"
      end

      it "will raise an exception if searching by id" do
        expect {model.find_all_by(id: instance.id)}.to raise_error(ArgumentError)
      end

      it "will return an empty array if none can be found" do
        expect(model.find_all_by(zombies: 'yes plz')).to be_empty
      end

      it "will raise an exception if none can be found with a !" do
        expect { model.find_all_by! brains: :none }.to raise_error(Rrod::Model::NotFound)
      end
    end
  end

end
