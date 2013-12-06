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
    expect(instance.as_json).to eq(JSON.parse instance.to_json)
  end

end
