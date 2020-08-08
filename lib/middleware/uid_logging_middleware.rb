class UidLoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.has_header?("HTTP_UID")
      Rails.logger.info "RACK REQ HEADERS uid: #{request.get_header('HTTP_UID')}"
    end

    status, headers, response = @app.call(env)
    if headers["uid"]
      Rails.logger.info "RACK RESPONSE HEADERS uid: #{headers['uid']}"
    end
    [status, headers, response]
  end
end
