class Api::V1::CategoryController < ActionController::API

  def index
    user = Company.find(params["user_id"])
    render json: user.responses.get_categories
  end

  def create
    user = Company.find(params["user_id"])
    render json: user.responses.analyze_category(params["question"], params["response"], params["domain"]), serializer: StatisticSerializer
    # render json: ToneResponse.new(params["question"], params["response"]).analyze_category(params["user_id"], params["domain"])
  end

end
