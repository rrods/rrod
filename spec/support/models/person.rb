class Address
  include Rrod::Model

  attribute :street,     String
  attribute :city,       String
  attribute :state_abbr, String   
  attribute :zip,        String
end

class Vaccination
  include Rrod::Model

  attribute :type, String
  attribute :when, Date
end

class Pet
  include Rrod::Model
  nested_in :owner

  attribute :name,     String
  attribute :species,  String
  attribute :friendly, Boolean

  attribute :vaccinations, [Vaccination], default: -> { 
    Vaccination.new(type: :rabies, when: Date.today)
  }
end

class Person
  include Rrod::Model

  after_assignment :poke
  before_validation :stuffs
  before_save :other_stuffs

  attribute :name,    String,  index: true, presence: true
  attribute :age,     Integer, index: true, numericality: {min: 10}
  attribute :gender,  Symbol

  attribute :address, Address

  attribute :pets,    [Pet]

  validates_length_of :pets, minimum: 1

  private

  def stuffs
    'woo'
  end

  def other_stuffs
    'moar wooo'
  end

  def poke
    'poke'
  end
end
