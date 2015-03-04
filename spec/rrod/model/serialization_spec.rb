require 'spec_helper'
require 'support/models/car'

describe Rrod::Model::Serialization do
  let(:model) { Car }
  let(:attributes) { {wheels: 5, make: 'Jeep' } }
  let(:instance) { model.new(attributes) }

  it "serializes its attributes for json" do
    hash = attributes.stringify_keys.tap { |h| h['id'] = h['color'] = nil }
    expect(instance.as_json).to eq hash
  end

  it "calls to_json on its as_json representation" do
    expect(instance.as_json).to eq(JSON.parse instance.to_json)
  end

  it "includes the id in the standard json representation" do
    expect(instance.as_json.keys).to include("id")
  end

end
