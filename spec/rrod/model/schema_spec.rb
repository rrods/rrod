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

  describe "associations", integration: true do

    it "allows embedding other Rrod::Model's as attributes" do
      instance.address        = Address.new
      instance.address.street = '123 Fancy Pants Court'
      instance.save(validate: false)
      person = Person.find(instance.id)
      expect(person.address).to be_an Address
      expect(person.address.street).to eq '123 Fancy Pants Court'
    end

    it "allows embedding an array of Rrod::Model's as an attribute" do
      instance.pets = [Pet.new(name: 'Molle')]
      instance.save(validate: false)
      person = Person.find(instance.id)
      expect(person.pets).to be_an Rrod::Model::Collection
      expect(person.pets.first).to be_a Pet
      expect(person.pets.first.name).to eq 'Molle'
    end

    it "will properly serialize nested models" do
      instance.address = Address.new(street: '123 Fancy Pants Lane')
      instance.pets    = [Pet.new(name: 'Molle')]
      instance.name    = 'Zoolander'
      hash             = instance.serializable_hash

      expect(hash).to be_a Hash
      expect(hash['pets']).to    eq [{'name' => 'Molle'}]
      expect(hash['address']).to eq 'street' => '123 Fancy Pants Lane'
    end

  end

end
