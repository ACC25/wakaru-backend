class Api::V1::CategoryController < ActionController::API

  def create
    render json: ToneResponse.new(params["question"], params["response"]).analyze_category
  end

end
