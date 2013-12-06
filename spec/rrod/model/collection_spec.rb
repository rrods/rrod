require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Collection do
  let(:array)      { [Pet.new] }
  let(:collection) { described_class.new(array) }

  describe "initialization" do
    it "takes a collection" do
      expect(collection.collection).to eq(array)
    end

    describe "errors" do
      describe "non enumerable" do
        let(:array) { Object.new }
        it "raises" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidCollectionTypeError)
        end
      end

      describe "not all Rrod::Model" do
        let(:array) { [Object.new] }
        it "raises if not all `Rrod::Model`s" do
          expect { collection }.to raise_error(Rrod::Model::Collection::InvalidMemberTypeError)
        end
      end
    end
  end
end
