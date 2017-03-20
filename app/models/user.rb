class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :login, :role_ids, :admin_edit, :current_password, :old_log_view
  
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :verifications

  attr_accessor :login

  before_create :set_default_role

  def self.find_first_by_auth_conditions(warden_conditions)
  	conditions = warden_conditions.dup

  	if login = conditions.delete(:login)
  		where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  	else
  		where(conditions).first
  	end
  end

  def role?(role)
  	return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def set_default_role
  	if self.role_ids.empty?
  		if User.count == 0
  			self.role_ids = [1]
  		else
  			self.role_ids = [3]
  		end
  	end
  end

end
