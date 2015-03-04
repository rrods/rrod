class Address
  include Rrod::Model
  nested_in :resident

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
  before_create :created!
  before_update :updated!

  attribute :name,    String,  presence: true
  attribute :age,     Integer, numericality: {min: 10}
  attribute :gender,  Symbol

  attribute :likes_pets, Boolean, default: true
  attribute :comments,   Array,   default: -> { [build_comment] }

  attribute :address, Address

  attribute :pets,    [Pet]

  validates_length_of :pets, minimum: 1

  def build_comment
    {name: 'Adam', text: 'What kind of comment is this really?'}
  end

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

  def created! ; end
  def updated! ; end
end
