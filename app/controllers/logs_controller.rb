class LogsController < ApplicationController
	has_scope :title
	has_scope :author
	has_scope :game
	has_scope :category
	has_scope :order_by, :default => "DESC"

    # GET /logs
    # GET /logs.json
    def index
			can_see_priv = !!(user_signed_in? and current_user.role? :admin)
    	@logs = apply_scopes(Log.select('creator,owner,category,game,author,title,private,token,created_at'))
			if !can_see_priv
				@logs = @logs.where(:private => false)
			end
			@logs = @logs.paginate(:page => params[:page], :per_page => 25)
    	@games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
    	@categories = Hash[Category.all.collect {|c| [c.id, c.name] }.push([0, "Other"])]
    end

	# GET /logs/zEqAs
	# GET /logs/zEqAs.json
	def show
		@log = Log.find_by_token(params[:id]) || not_found
		@games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
	end

	# GET /logs/new
	# GET /logs/new.json
	def new
		@log = Log.new
	end

	# GET /logs/1/edit
	def edit
		@log = Log.find_by_token(params[:id])
		authorize! :edit, @log
	end

	# POST /logs
	# POST /logs.json
  def create
		file_contents = ""
    if params[:log][:file]
    	uploaded_file = params[:log][:file]
      if uploaded_file.size > 32.megabytes
      	@log = Log.new
        flash.now[:error] = "Max file size at this time is 32M."
        render action: "new"
      	return false
      end
      file_contents = uploaded_file.read
		elsif params[:log][:log_contents] and !params[:log][:log_contents].blank?
			file_contents = params[:log][:log_contents]
			if file_contents.bytesize > 32.megabytes
				@log = Log.new
				flash.now[:error] = "Max file size at this time is 32M."
				render action: "new"
				return false
			end 
		else
			@log = Log.new
			flash.now[:error] = "You must include a log"
			render action: "new"
			return false
		end
			file_contents.gsub!(/[[:^ascii:]]/, "")
			encoding = 'ASCII'
			if file_contents.methods.include?(:encoding) #Ruby 1.8 Compat
				if file_contents.encoding != encoding
					encoding = file_contents.encoding
				end
			end
			file_contents.gsub!(/<!DOCTYPE((.|\n|\r)*?)">/, '')
			file_contents.gsub!(/\n\n/, "\n")
                        if file_contents.index("\e") then
                                bold = false
                                curr_fg = "silver"
                                curr_bg = "black"
                                first = true
                                colours = ["black", "maroon", "green", "olive", "navy", "purple", "teal", "silver", "gray", "red", "lime", "yellow", "blue", "magenta", "cyan", "white"]
                                file_contents.gsub!(/\e\[([0-9;]+)m/) { |match|
                                        s = first ? "" : "</span>"
                                        first = false
                                        codes = $1.split(";")
                                        codes.each {|code|
                                                if code.to_i == 0 then
                                                        bold = false
                                                        curr_fg = "silver"
                                                        curr_bg = "black"
                                                elsif code.to_i == 1 then
                                                        bold = true
                                                elsif code.to_i == 22 then
                                                        bold = false
                                                elsif 29 < code.to_i && code.to_i < 38 then
                                                        cc = code.to_i - 30
                                                        if bold then
                                                                cc += 8
                                                        end
                                                        curr_fg = colours[cc]
                                                elsif 39 < code.to_i && code.to_i < 48 then
                                                        cc = code.to_i - 40
                                                        if bold then
                                                                cc += 8
                                                        end
                                                        curr_bg = colours[cc]
                                                elsif code.to_i == 39 then
                                                        curr_fg = "white"
                                                elsif code.to_i == 49 then
                                                        curr_bg = "black"
                                                end
                                        }
                                        s += "<span style=\"color: #{curr_fg}; background-color: #{curr_bg};\">"
                                        s
                                }
                        end
                        #hf = HTMLFilter.new({'allowed' => {'b'  => ['class', 'id', 'style', 'title'],'basefont' => ['color', 'face', 'size'], 'bdo'  => ['class', 'dir', 'lang', 'id', 'style', 'title'], 'br' => ['class', 'id'], 'center' => ['class', 'id', 'style', 'title'],'div'  => ['class', 'align', 'style', 'id', 'style', 'title'],'em'  => ['class', 'id', 'style', 'title'],'font' => ['face', 'size', 'color', 'class', 'id', 'style', 'title'],'i'  => ['class', 'id', 'style', 'title'],'p'  => ['align', 'class', 'id', 'style', 'title'],'pre' => ['class', 'id', 'style', 'title'],'s'  => ['class', 'id', 'style', 'title'],'span'  => ['class', 'id', 'style', 'title'],'strong'  => ['class', 'id', 'style', 'title'], 'u'  => ['class', 'id', 'style', 'title'],},'no_close' => ['img', 'br', 'hr'],'always_close' => ['a', 'b'],'protocol_attributes' => ['src', 'href'],'allowed_protocols' => ['http', 'ftp', 'mailto', 'https', 'sftp'],'remove_blanks' => ['a', 'b'],'strip_comments' => true, 'always_make_tags' => false,'allow_numbered_entities' => true,'allowed_entities' => ['amp', 'copy', 'gt', 'lt', 'nbsp', 'quot', 'apos', '#60', '#63', '#8216']})
                        #filtered_html = hf.filter(file_contents)
												#filtered_html.encode!()
												node_arr = ['b','br','center','div','em','font','i','p','strong','u','pre','s','span']
												logsty_filter = Loofah::Scrubber.new do |node|
													node.remove if node.name == "input"
													node.remove if node.name == "button"
													if node.name == "div" and node['id'] == "options"
														node.remove #For Martin's HTML5 script
													end
												end
												file_contents.encode!()
												filtered_html = Loofah.fragment(file_contents).scrub!(:prune).scrub!(logsty_filter).to_s
												filtered_html.gsub!(/<br\s*\/?>(?:<\/br>)?[\r\n]+/, "\n")
												filtered_html.strip!

                        params[:log][:contents] = filtered_html
                        params[:log].delete(:file)
                @log = Log.new(params[:log])

                if @log.save
                        redirect_to url_for(:controller => 'logs', :action => 'show', :id => @log.token), notice: 'Log was successfully created.'
                else
                        if @log.nil? then
                                @log = Log.new
                        end
                        render action: "new"
                end
        end


	# PUT /logs/1
	# PUT /logs/1.json
	def update
		@log = Log.find_by_token(params[:id])
		authorize! :edit, @log

		if @log.update_attributes(params[:log])
			redirect_to url_for(:controller => 'logs', :action => "show", :id => params[:id]), notice: 'Log was successfully updated.'
		else
			render action: "edit"
		end
	end

	# DELETE /logs/1
	# DELETE /logs/1.json
	def destroy
		@log = Log.find_by_token(params[:id])
		authorize! :destroy, @log
		@log.destroy
		redirect_to logs_url
	end

	def comment
		params[:comment][:modpost] = params[:comment][:modpost] or false
		@log = Log.find_by_token(params[:id])
		@log.comments.create(params[:comment])
		flash[:notice] = "Comment posted."
		redirect_to :action => "show", :id => params[:id]
	end

	def feed
		# this will be the name of the feed displayed on the feed reader
		@title = "CocoLog"

		# the news items
		@logs = Log.where(:private => false).order("created_at desc")

		# this will be our Feed's update timestamp
		@updated = @logs.first.created_at unless @logs.empty?

		@games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
		@categories = Hash[Category.all.collect {|c| [c.id, c.name] }.push([0, "Other"])]

		respond_to do |format|
			format.atom { render :layout => false }

	  		# we want the RSS feed to redirect permanently to the ATOM feed
	  		format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
	  	end
	end

	def raw
                @log = Log.find_by_token(params[:id]) || not_found
		if @log.downloadable == false
			if not user_signed_in?
				redirect_to :action => "show", :id => params[:id]
				return
			elsif not current_user.role?(:admin) and current_user.id != @log.owner.to_i
				redirect_to :action => "show", :id => params[:id]
				return
			end
		end
		render :layout => 'raw'
        end

        def download
                @log = Log.find_by_token(params[:id]) || not_found
                if @log.downloadable == false
                        if not user_signed_in?
                                redirect_to :action => "show", :id => params[:id]
                                return
                        elsif not current_user.role?(:admin) and current_user.id != @log.owner.to_i
                                redirect_to :action => "show", :id => params[:id]
                                return
                        end
                end
		headers['Content-Disposition'] = "attachment; filename=\"#{params[:id]}.html\""
                render :layout => 'raw'
        end

	private
		def get_regex(pattern, encoding='ASCII', options=0)
        	        Regexp.new(pattern.encode(encoding),options)
	        end

end

