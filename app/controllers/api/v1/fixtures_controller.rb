class Api::V1::FixturesController < ActionController::API

  def index
    token = JwtService.new(params).decode
    if token && token != nil
      user = Company.find(token["user_id"])
      render json: user.responses.get_fixtures
    else
      render json: {error: "Unauthorized Access. Permission Denied."}
    end
  end

  def update
    token = JwtService.new(params).decode
    if token && token != nil
      fixture = Response.find(params["id"])
      user = Company.find(token["user_id"])
      if fixture.update(domain: 0)
        render json: user.responses.reset_category(fixture.id), serializer: FixturesSerializer
      else
        render json: "Fixture could not be removed."
      end
    else
      render json: {error: "Unauthorized Access. Permission Denied."}
    end
  end

end
