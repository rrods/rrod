require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Collection do
  let(:array)      { [Pet.new] }
  let(:collection) { described_class.new(array) }

  describe "initialization" do
    it "takes a collection" do
      expect(collection.collection).to eq(array)
    end

    it "defaults to an empty collection" do
      expect(described_class.new.collection).to be_an Array
    end

    describe "errors" do
      describe "non enumerable" do
        let(:array) { Object.new }
        it "raises" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidCollectionTypeError)
        end
      end

      describe "not all Rrod::Model" do
        let(:array) { [Pet.new, Object.new] }
        it "raises if not all `Rrod::Model`s" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidMemberTypeError)
        end

        it "clears the collection" do
          collection = described_class.new
          begin; collection.collection = array; rescue; end
          expect(collection.collection).to be_empty
        end
      end
    end
  end
end
