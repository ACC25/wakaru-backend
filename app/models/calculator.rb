class Calculator
  attr_reader :user_id,
              :domain,
              :tones,
              :category

  def initialize(user_id, domain, tones, category = nil)
    @user_id = user_id
    @domain = domain
    @tones = tones
    @category = category
  end

  def find_relations
    good_results = relations(0)
  end

  private

  def relations(category)
    tones.each_pair do |key, value|
      binding.pry
      BaseResponse.where(category: category)
    end
  end

end
