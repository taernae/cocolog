class Log < ActiveRecord::Base
  attr_accessible :author, :contents, :description, :game, :private, :title, :token, :file, :category, :owner, :creator, :downloadable, :created_at, :log_contents
	attr_accessor :log_contents
  has_many :comments

  scope :title, lambda { |t| where("title LIKE ?", "%#{t}%") }
  scope :author, lambda { |a| where("author LIKE ?", "%#{a}%") }
  scope :game, lambda { |gid| where(:game => gid) }
  scope :category, lambda { |cid| where(:category => cid) }
  scope :order_by, lambda { |dir| order("created_at #{dir}") }
  scope :showonlypublic_s, lambda { where(:private => false) }

  uniquify :token do
  	Array.new(5){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end

  validates :game, :presence=>true
  validates :contents, :presence=>true
  validates :title, :presence=>true, :length=>{:minimum=>4}

  def log_path(log)
  	"/log/#{log.token}"
  end
end
