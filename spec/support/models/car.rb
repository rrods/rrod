class Car
  include Rrod::Model
  attribute :make,   String,  index: true
  attribute :wheels, Integer, index: true
  attribute :color,  String
end
