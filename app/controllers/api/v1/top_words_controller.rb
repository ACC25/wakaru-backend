class Api::V1::TopWordsController < ActionController::API

  def index
    user = Company.find(params["user_id"])
    render json: user.responses.top_words(params["category"])
  end

end
