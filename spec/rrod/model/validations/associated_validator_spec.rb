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
      arod.should_not be_valid
      joeschmo.should_not be_valid
      team.should_not be_valid
    end
 
    it 'includes the associated records validation error messages in the error message' do 
      team.valid?
      team.errors[:players].size.should == 1
      # maybe change this to better error messages
      team.errors[:players].first.should == "Name can't be blank"
    end  

 
    it 'is valid when the associated records are valid' do
      ichiro.should be_valid
      
      arod.name = 'Alex Rodriguez'
      arod.should be_valid
      
      joeschmo.name = 'Joe Schmo' 
      joeschmo.position = 'C'
      joeschmo.should be_valid
  
      team.should be_valid
    end

  end
end
