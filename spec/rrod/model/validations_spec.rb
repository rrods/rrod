require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Validations do
  let(:klass)      { Person }
  let(:validators) { klass.validators }
  let(:instance)   { klass.new }

  it "adds validations as class methods" do
    expect(validators.any? { |v| ActiveModel::Validations::LengthValidator === v }).to be_truthy
  end

  it "allows describing validations in the attribute" do
    expect(validators.any? { |v| ActiveModel::Validations::PresenceValidator === v }).to be_truthy
  end

  it "raises a no method error if no validation exists" do
    expect {
      Class.new {
        include Rrod::Model
        attribute :kittens, Integer, bunnies: true
      }
    }.to raise_error(ArgumentError, /BunniesValidator/)
  end


  it "can determine an instances validity" do
    expect(instance).not_to be_valid
  end

  it "will not save if invalid" do
    expect(instance).not_to receive(:persist)
    instance.save
  end

  it "will return false from saving if invalid" do
    expect(instance.save).to be_falsey
  end

  it "sets up errors properlies" do
    instance.valid?
    expect(instance.errors).to be_present
  end

  it "will allow saving when not validating" do
    expect(instance.save(validate: false)).to be_truthy
  end
end
