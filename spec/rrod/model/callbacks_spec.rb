require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Callbacks do
  let(:instance) { Person.new }

  describe "assignment" do
    it "provides callbacks" do
      expect(instance).to receive(:poke)
      instance.attributes = {name: 'Pooka'}
    end
  end

  describe "validation" do
    it "provides callbacks" do
      expect(instance).to receive(:stuffs)
      instance.valid?
    end
  end

  describe "saving" do
    it "provides callbacks" do
      expect(instance).to receive(:other_stuffs)
      instance.save
    end

    describe "create" do
      it "runs when new" do
        expect(instance).to receive(:created!)
        expect(instance).not_to receive(:updated!)
        instance.save
      end

      it "does not run when persisted" do
        instance.instance_variable_set :@persisted, true
        expect(instance).not_to receive(:created!)
        instance.save
      end
    end

    describe "update" do
      before :each do
        instance.instance_variable_set :@persisted, true
      end

      it "runs when persisted" do
        expect(instance).to receive(:updated!)
        expect(instance).not_to receive(:created!)
        instance.save
      end

      it "does not run when new" do
        instance.instance_variable_set :@persisted, false
        expect(instance).not_to receive(:updated!)
        instance.save
      end
    end
  end

end
