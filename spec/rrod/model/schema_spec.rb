require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Schema do

  let(:model)    { Person }
  let(:instance) { model.new }

  it "defines a reader for the attribute" do
    expect(instance).to respond_to(:name)
  end

  it "defines a writer for the attribute" do
    expect(instance).to respond_to(:name=)
  end

  it "will properly typecast when writing an attribute" do
    instance.gender = 'female'
    expect(instance.gender).to be :female
  end

  it "is using a schema if an attribute is declared" do
    expect(Person.schema?).to be_true
  end

end
