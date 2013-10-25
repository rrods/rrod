require 'spec_helper'
require 'support/models/car'

describe Rrod::Model::Serialization do
  let(:model) { Car }
  let(:attributes) { {wheels: 5, make: 'Jeep' } }
  let(:instance) { model.new(attributes) }

  it "serializes its attributes for json" do
    expect(instance.as_json).to eq attributes.stringify_keys
  end

  it "calls to_json on its as_json representation" do
    instance.stub(:as_json).and_return(attributes)
    expect(instance.as_json).to receive(:to_json)
    instance.to_json
  end

end
