class Team
  include Rrod::Model
  attribute :players, [Player]
  validates_associated :players
end
