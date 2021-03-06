require 'spec_helper'

describe Rrod::Model::Attribute do
  let(:options)   { {presence: true} }
  let(:model)     { Class.new { include Rrod::Model } }
  let(:instance)  { model.new }
  let(:name)      { :name }
  let(:type)      { String }
  let(:attribute) { described_class.new(model, name, type, options) }

  it "has a model" do
    expect(attribute.model).to be model
  end

  it "has a name" do
    expect(attribute.name).to be name
  end

  it "typecasts name to a symbol when initializing" do
    attribute = described_class.new(model, "unicorn_tears", Integer)
    expect(attribute.name).to be :unicorn_tears
  end

  it "has a type" do
    expect(attribute.type).to be type
  end

  it "has options" do
    expect(attribute.options).to eq(options)
  end

  describe "defining attribute methods" do
    before(:each) { attribute.define }

    describe "getters" do
      it "is defined on the declaring class" do
        expect(instance).to respond_to(name)
      end
    end

    describe "setters" do
      it "is defined on the declaring class" do
        expect(instance).to respond_to("#{name}=")
      end
    end

    describe "presence" do
      it "checks for presence" do
        expect(instance).to respond_to("#{name}?")
      end
    end

    describe "default" do
      it "adds the default" do
        expect(instance).to respond_to("#{name}_default")
      end
    end

    describe "attribute definitions" do
      it "adds the attribute definition to to model class" do
        expect(model).to respond_to("rrod_attribute_#{name}")
      end

      it "allows access to the attribute from the class" do
        expect(model.send("rrod_attribute_#{name}")).to eq attribute
      end
    end

    describe "attribute methods" do
      it "declares the attribute an ActiveModel attribute method" do
        expect(model).to receive(:define_attribute_method).with(name)
        attribute.define
      end
    end
  end

  describe "casting" do
    it "will use the types rrod_cast method if available" do
      type = Class.new {
        def self.rrod_cast(value, instance)
          value.to_s.upcase
        end
      }
      model.attribute :example, type
      instance.example = 'shorty'
      expect(instance.example).to eq 'SHORTY'
    end

    it "will look for a register Rrod caster if the type cannot cast itself" do
      model.attribute :example, String
      instance.example = :whazzup
      expect(instance.example).to eq('whazzup')
    end

    it "will simply return the value if all else fails" do
      model.attribute :example, Class.new
      instance.example = self
      expect(instance.example).to be self
    end

    describe "nested rrod models" do
      let(:type) { [Class.new { include Rrod::Model }] }

      it "can detect if the type is a nested rrod model" do
        expect(attribute.send :nested_model?).to be true
      end

      it "adds a rrod_cast method to the nested rrod model reference object" do
        attribute
        expect(type).to respond_to(:rrod_cast)
      end
    end
  end
end
