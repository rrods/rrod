require 'spec_helper'

describe Rrod do
  it "is the ruby riak database" do
    expect(described_class).to be_a Module
  end

  it "has a version" do
    expect(described_class.const_get "VERSION").to be_a String
  end
end

