class Verification < ActiveRecord::Base
  attr_accessible :name, :game_id, :approved
  has_and_belongs_to_many :users
end
