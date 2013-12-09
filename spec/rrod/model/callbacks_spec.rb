require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Callbacks do
  let(:instance) { Person.new }

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
  end

end
