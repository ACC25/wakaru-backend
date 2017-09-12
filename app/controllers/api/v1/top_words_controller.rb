class Api::V1::TopWordsController < ActionController::API

  def index
    token = JwtService.new(params).decode
    if token && token != nil
      user = Company.find(token["user_id"])
      render json: user.responses.top_words(params["category"])
    else
      render json: {error: "Unauthorized Access. Permission Denied."}
    end
  end

end
