class WatsonService
  attr_reader :text

  def initialize(user = nil, string)
    @user = user
    @text = string
  end


  private

end
