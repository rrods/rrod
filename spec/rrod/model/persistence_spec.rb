require 'spec_helper'
require 'support/models/car'

describe Rrod::Model::Persistence, integration: true do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  describe "instance methods" do
    describe "new models" do
      it "is new" do
        expect(instance).to be_new
      end

      it "aliases new_record?" do
        expect(instance).to be_a_new_record
      end

      it "is not persisted" do
        expect(instance).not_to be_persisted
      end
    end

    describe "persisted models" do
      before :each do
        instance.save
      end
     
      it "is persisted" do
        expect(instance).to be_persisted
      end

      it "is not new" do
        expect(instance).to_not be_new
      end

      it "has an id" do
        expect(instance.id).not_to be_nil
      end
    end

    describe "update models" do
      before :each do
        instance.save
      end

      it "updates attributes" do 
        instance.update wheels: 6
        expect(instance.wheels).to eq 6
      end


    end
  end
end
