class Player
  include Rrod::Model
  nested_in :team
  attribute :name,     String, presence: true
  attribute :position, String, presence: true
end
