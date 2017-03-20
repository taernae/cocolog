class UsersController < ApplicationController
	# GET /users
	# GET /users.json
	def index
		authorize! :show, User
		@users = User.order("id DESC")
	end

	# GET /users/new
	# GET /users/new.xml
	# GET /users/new.json                                    HTML AND AJAX
	#-------------------------------------------------------------------
	def new
		authorize! :edit, User
		@user = User.new
	end

	# GET /users/1
	# GET /users/1.xml
	# GET /users/1.json                                     HTML AND AJAX
	#-------------------------------------------------------------------
	def show
		@user = User.find(params[:id])
		authorize! :show, User
		@logs = Log.where(:owner => @user.id)
                @games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
                @categories = Hash[Category.all.collect {|c| [c.id, c.name] }.push([0, "Other"])]
	end

	# GET /users/profile
	#-------------------------------------------------------------------
	def profile
		render :status => :forbidden unless user_signed_in?
		@user = current_user
		authorize! :edit, @user
		@logs = Log.where(:owner => @user.id)
 		@games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
		@categories = Hash[Category.all.collect {|c| [c.id, c.name] }.push([0, "Other"])]
	end

	# GET /users/1/edit
	# GET /users/1/edit.xml
	# GET /users/1/edit.json                                HTML AND AJAX
	#-------------------------------------------------------------------
	def edit
		@user = User.find(params[:id])
		authorize! :edit, User #Use profile for editing own
	end

	# DELETE /users/1
	# DELETE /users/1.xml
	# DELETE /users/1.json                                  HTML AND AJAX
	#-------------------------------------------------------------------
	def destroy
		authorize! :delete, User
		@user = User.find(params[:id])
		@user.destroy!
		flash[:notice] = "User \##{:id} deleted."
		redirect_to :action => :index
	end

	# POST /users
	# POST /users.xml
	# POST /users.json                                      HTML AND AJAX
	#-----------------------------------------------------------------
	def create
		authorize! :create, User
		@user = User.new(params[:user])
		@user.skip_confirmation!

		if @user.save
			flash[:notice] = "Created user '#{params[:user][:username]}(\##{@user.id})'"
			redirect_to :action => :index
		else
			render :action => :new, :status => :unprocessable_entity
		end
	end

	# PUT /users/1
	# PUT /users/1.xml
	# PUT /users/1.json                                            HTML AND AJAX
	#----------------------------------------------------------------------------
	def update
		@user = User.find(params[:id])
		authorize! :edit, @user
		if params[:user][:password].blank?
			[:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
		else
			@user.errors[:base] << "The password you entered is incorrect" unless (@user.valid_password?(params[:user][:current_password]) or params[:user][:admin_edit])
			@user.errors[:base] << "Passwords do not match" unless params[:user][:password] == params[:user][:password_confirmation]
			@user.errors[:base] << "Password is too short" unless params[:user][:password].length > 5
		end

		[:admin_edit, :current_password].each do |field| 
			params[:user].delete(field)
		end

		
		if @user.errors[:base].empty? and @user.update_attributes(params[:user])
			sign_in(@user, :bypass => true)
			flash[:notice] = "Your account has been updated"
			redirect_to :back
		else
			flash[:error] = @user.errors[:base].to_a.join('/')
			redirect_to :back
		end
	end

	# Get roles accessible by the current user
	#----------------------------------------------------
	def accessible_roles
		@accessible_roles = Role.accessible_by(current_ability,:read)
	end

	# Make the current user object available to views
	#----------------------------------------
	def get_user
		@current_user = current_user
	end
end
