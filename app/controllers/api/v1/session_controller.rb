class Api::V1::SessionController < ActionController::API

  def create
    user = Company.new(name: params["username"], password: params["password"])
    if user.save
      token = JwtService.new(user).encode
      render json: {token: token}
    else
      render json: {error: "Account could not be created."}
    end
  end

  def index
    user = Company.find_by(name: params["username"])
    if user && user.authenticate(params["password"])
      token = JwtService.new(user).encode
      render json: {token: token}
    else
      render json: {error: "Invalid login credentials."}
    end
  end

end
