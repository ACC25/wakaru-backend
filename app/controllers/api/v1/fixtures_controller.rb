class Api::V1::FixturesController < ActionController::API

  def index
    user = Company.find(params["user_id"])
    render json: user.responses.get_fixtures
  end

end
