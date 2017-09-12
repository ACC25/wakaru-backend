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

  def decode
    begin
    decoded_token = JWT.decode(request["token"], ENV['rails_secret_key_base'], true, { :algorithm => 'HS256' })
    decoded_token[0]
    rescue
      nil
    end
  end
end
