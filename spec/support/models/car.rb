class Accessory
  include Rrod::Model
  attribute :name, String

  def key
   name.underscore.to_sym
  end

end

class Car
  include Rrod::Model
  attribute :make,   String,  index: true
  attribute :wheels, Integer, index: true
  attribute :color,  String
  attribute :accessories, {key: Accessory}
end
