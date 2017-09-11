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

end
