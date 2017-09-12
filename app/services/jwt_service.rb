class JwtService
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def encode
    payload = {user_id: request.id}
    token = JWT.encode(payload, ENV['rails_secret_key_base'], 'HS256')
    request.update!(auth_token: token)
    token
  end

end
