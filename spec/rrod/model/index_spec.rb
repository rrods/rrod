require 'spec_helper'
require 'support/models/person'

describe Rrod::Model::Index do
  let(:model)     { Person }
  let(:name)      { :name }
  let(:attribute) { Rrod::Model::Attribute.new(model, name, String, {})}
  let(:index)     { described_class.new(attribute) }
  let(:instance)  { model.new }

  it "has an index name with correct type" do
    expect(index.name).to eq "name_bin"
  end

  it "will correctly cast an attribute" do
    instance.name = "Batman"
    expect(index.cast(instance)).to eq "Batman"  
  end

end
