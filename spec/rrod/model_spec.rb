require 'spec_helper'
require 'support/models/car'

describe Rrod::Model do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  describe "including" do
    describe "class methods" do
      it "delegates the client to the Rrod::Model module" do
        expect(Rrod.configuration).to receive :client
        model.client
      end

      it "has a riak client" do
        expect(model.client).to be_a Riak::Client
      end

      it "has a bucket" do
        expect(model.bucket).to be_a Riak::Bucket
      end

      it "names the bucket based off the class" do
        expect(model.bucket.name).to eq 'cars'
      end

      it "uses anonymous for the bucket name on unnamed classes" do
        expect(Class.new { include Rrod::Model }.bucket.name).to eq Rrod::Model::Schema::ANONYMOUS
      end
    end

    describe "instance methods" do
      it "delegates the client to the Car" do
        expect(model).to receive :client
        instance.client
      end

      it "has a riak client" do
        expect(instance.client).to be_a Riak::Client
      end

      it "delegates its bucket to its class" do
        expect(model).to receive :bucket
        instance.bucket
      end

      it "has a bucket" do
        expect(instance.bucket).to be_a Riak::Bucket
      end

      it "is inspectable" do
        inspectable = BatMobile.new(wheels: 7, weapons: [{type: 'Gattling Gun', damage: 4_321}])
        # used for human debugging of inspection output
        # expect(inspectable.inspect).to eq("fancy string")
        expect(inspectable.inspect).to be_a String
      end
    end
  end
end
