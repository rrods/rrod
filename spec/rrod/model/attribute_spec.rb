require 'spec_helper'

describe Rrod::Model::Attribute do
  let(:options)   { {fancy: true} }
  let(:attribute) { described_class.new(:name, String, options) }

  it "has a name" do
    expect(attribute.name).to be :name
  end

  it "typecasts name to a symbol when initializing" do
    attribute = described_class.new("unicorn_tears", Integer)
    expect(attribute.name).to be :unicorn_tears
  end

  it "has a type" do
    expect(attribute.type).to be String
  end

  it "has options" do
    expect(attribute.options).to eq(options)
  end

  describe "defaults" do
    context "when a value" do
      let(:options) { {default: 'SOO fluffy!'} }
      it "can provide a default value" do
        expect(attribute.default).to eq 'SOO fluffy!'
      end
    end

    context "when a proc" do
      let(:options) { {default: -> { 'alligator' }} }

      it "can provide a default value if a proc" do
        expect(attribute.default).to eq 'alligator'
      end
    end
  end
end
