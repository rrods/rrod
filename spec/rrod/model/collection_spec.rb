require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Collection do
  let(:array)      { [Pet.new] }
  let(:collection) { described_class.new(Pet, array) }

  describe "initialization" do
    it "takes a collection" do
      expect(collection.collection).to eq(array)
    end

    it "defaults to an empty collection" do
      expect(described_class.new(Pet).collection).to be_an Array
    end

    describe "#build" do 
      it "adds to the collection" do
        collection.build(name: 'Lion')
        expect(collection.collection.length).to eq 2
        expect(collection.collection.last.name).to eq('Lion')
      end

      it "returns the built object" do
        object = collection.build(name: 'Molle')
        expect(object).to be_a(Pet)
      end
    end


    describe "errors" do
      describe "non enumerable" do
        let(:array) { Object.new }
        it "raises" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidCollectionTypeError)
        end
      end

      describe "not all same Rrod::Model" do
        let(:array) { [Pet.new, Address.new] }
        it "raises if not all `Rrod::Model`s" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidMemberTypeError)
        end

        it "clears the collection" do
          collection = described_class.new(Pet)
          begin; collection.collection = array; rescue; end
          expect(collection.collection).to be_empty
        end
      end
    end
  end
end
