class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin
        can :manage, :all
    elsif user.role? :moderator
        can :manage, [Log]
    elsif user.role? :authenticated_user
        can :manage, Log do |log|
            log.try(:owner) == user.id
        end
	can :edit, User do |u|
	    u.id == user.id
	end
	can :update, User do |u|
	    u.id == user.id
	end
    end
  end
end
