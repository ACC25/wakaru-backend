class FixturesController < ActionController::API

  def index
    user = Company.find(params["user_id"])
    render json: user.responses.find_fixtures
  end

end
