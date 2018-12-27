class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authorized, except: [:issue_token, :decode_token, :logged_in?]

  def issue_token(payload)
    JWT.encode(payload, ENV['JWT_SECRET'])
  end

  def decode_token(payload)
    begin
      JWT.decode(payload, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])
    rescue JWT::DecodeError
      return nil
    end
  end

  def current_user
    # pull jwt token out of request.headers (assumed to be in format: {Authorization: "Token token=xxx"})
    authenticate_or_request_with_http_token do |jwt_token, options|
      decoded_token = decode_token(jwt_token)
      # if a decoded token is found, use it to return a user
      if decoded_token
        user_id = decoded_token[0]["user_id"]
        @current_user ||= SpotifyUser.find_by(id: user_id)
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    # Respond with error message, unless user is logged in
    render json: {error: "Access Denied. Please log in."}, status: 401 unless logged_in?
  end

end
