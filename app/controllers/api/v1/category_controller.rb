class Api::V1::CategoryController < ActionController::API

  def index
    token = JwtService.new(params).decode
    if token && token != nil
      user = Company.find(token["user_id"])
      render json: user.responses.get_categories
    else
      render json: {error: "Unauthorized Access. Permission Denied."}
    end
  end

  def create
    token = JwtService.new(params).decode
    if token && token != nil
      user = Company.find(token["user_id"])
      render json: user.responses.analyze_category(params["question"], params["response"], params["domain"], params["category"]), serializer: StatisticSerializer
      user.responses.reclassify if params["domain"] == "1"
    else
      render json: {error: "Unauthorized Access. Permission Denied."}
    end
  end

end
