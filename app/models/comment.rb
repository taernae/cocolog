class Comment < ActiveRecord::Base
  attr_accessible :author, :body, :creator, :owner, :reply, :modpost
  belongs_to :log

  validates_presence_of :author
  validates_presence_of :body
end
