class Api::V1::FixturesController < ActionController::API

  def index
    user = Company.find(params["user_id"])
    render json: user.responses.get_fixtures
  end

  def update
    fixture = Response.find(params["id"])
    user = Company.find(params["user_id"])
    if fixture.update(domain: 0)
      render json: user.responses.reset_category(fixture.id), serializer: FixturesSerializer
    else
      render json: "Fixture could not be removed."
    end
  end

end
