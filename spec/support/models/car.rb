class Car
  include Rrod::Model
  attribute :make,   String
  attribute :wheels, Integer
  attribute :color,  String
end

class Seat
  include Rrod::Model
  attribute :ejected, Boolean, default: false
end

class Weapon
  include Rrod::Model
  attribute :type,   String
  attribute :damage, Integer
end

class BatMobile < Car
  include Rrod::Model
  attribute :make,    String, default: 'BatMobile'
  attribute :color,   String, default: 'Black'
  attribute :seat,    Seat,   default: -> { Seat.new }
  attribute :weapons, [Weapon]
end
