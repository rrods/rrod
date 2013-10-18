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

  attribute :name,     String
  attribute :species,  String
  attribute :friendly, Boolean

  attribute :vaccinations, [Vaccination], default: -> { 
    Vaccination.new(type: :rabies, when: Date.today)
  }
end

class Person
  include Rrod::Model

  attribute :name,   String
  attribute :age,    Integer
  attribute :gender, Symbol

  attribute :address, Address

  attribute :pets,   [Pet]
end
