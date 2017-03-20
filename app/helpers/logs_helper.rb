module LogsHelper
	def log_path(log, trashval="")
 		"/logs/#{log.token}"
  	end

  	def log_url(log)
  		"/logs/#{log.token}"
  	end

	def edit_log_path(log)
		"/logs/#{log.token}/edit"
	end

	def get_regex(pattern, encoding='ASCII', options=0)
		Regexp.new(pattern.encode(encoding),options)
	end
end
