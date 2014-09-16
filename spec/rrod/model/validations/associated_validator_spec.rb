require 'spec_helper'
require 'support/models/player'
require 'support/models/team'

describe Rrod::Model::Validations::AssociatedValidator do
  context 'for a many association' do
    # this is the same as a one association..
    let(:team)     { Team.new }
    let(:ichiro)   { Player.new(name: 'Ichiro', position: 'RF') }
    let(:arod)     { Player.new(position: '3B') }
    let(:joeschmo) { Player.new }
    
    before(:each) do
      team.players = [ichiro, arod, joeschmo]
    end

    it 'is invalid when the associated records are invalid' do
      expect(arod.valid?).to be false
      expect(joeschmo.valid?).to be false
      expect(team.valid?).to be false
    end
 
    it 'includes the associated records validation error messages in the error message' do 
      team.valid?
      expect(team.errors[:players].size).to be 1
      # maybe change this to better error messages
      error_message = team.errors[:players].first
      expect(error_message).to eq "Name can't be blank; Name can't be blank and Position can't be blank"
    end  

 
    it 'is valid when the associated records are valid' do
      expect(ichiro.valid?).to be true
      
      arod.name = 'Alex Rodriguez'
      expect(arod.valid?).to be true
      
      joeschmo.name = 'Joe Schmo' 
      joeschmo.position = 'C'
      expect(joeschmo.valid?).to be true
  
      expect(team.valid?).to be true
    end

  end
end
