class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_error
  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = exception.message
  	redirect_to '/'
  end
  #rescue_from DataMapper::ObjectNotFoundError, :with => :not_found
  rescue_from ActionController::RoutingError, :with => :not_found

  def respond_to_not_found(*types)
    flash[:warning] = t(:msg_asset_not_available, asset)

    respond_to do |format|
      format.html { redirect_to :action => :index }
      format.json { render :text => flash[:warning], :status => :not_found }
      format.all  { render :nothing => true, :status => :not_found }
    end
  end

  def not_found
    render 'static/notfound', :status => 404
  end

  def write_error(exception, guru_med)
    path = "#{Rails.root}/errors/" + guru_med + ".log"
    my_file = File.new(path, "a+")
    my_file.write "#{exception.class} (#{exception.message}):\n"
    my_file.write Rails.backtrace_cleaner.clean(exception.backtrace)
    my_file.write "\n\n"
    my_file.close
  end

	
  def render_error(exception)
	@guru_meditation = (0...12).map{(65+rand(26)).chr}.join
	write_error(exception, @guru_meditation)
	render :template => "static/error", :status => 500, :guru_med => @guru_meditation
  end
	
end
