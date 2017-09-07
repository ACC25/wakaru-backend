class Statistic
  attr_reader :db,
              :scores,
              :comments,
              :recommended_score

  def initialize(id)
    @db ||= Response.find(id)
    @scores = {
      enjoyment_score: {
        category_0: "",
        category_1: "",
        category_2: "",
        category_3: ""
      },
      big_five_score: {
        category_0: "",
        category_1: "",
        category_2: "",
        category_3: ""
      },
      dissatisfaction_score: {
        category_0: "",
        category_1: "",
        category_2: "",
        category_3: ""
      }
    }
    @overall_score = {
      enjoyment: "",
      brand: ""
    }
    @comments = {
      enjoyment: [],
      brand: []
    }
  end

  def find_my_category
    find_percentile_enjoyment
    find_percentile_dissastisfaction
    find_overall_score
  end

  def recommendation
  end

  def create_suggestions
    comments.each_pair do |k, v|
      k == :enjoyment ? comments[k] = query_enjoyment_words : comments[k] = query_brand_words
    end
  end

  private

  def find_percentile_dissastisfaction
    scores[:dissatisfaction_score].each do |k, v|
      scores[:dissatisfaction_score][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score)
      scores[:dissatisfaction_score][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score) if k == :category_3
    end
  end

  def query_enjoyment_words
    # above_average = ["enjoyable", "above-average", ""]
    # best = []
    # below_average = []
    # worst = []
    # output = []
    # if scores[:enjoyment_score][:category_0] >= 50.0
    #   "A customers experience with this email is likely #{good_words.sample}"
    # elsif scores
    # end
  end

  def query_brand_words
    bad_words = ["poor", "below-average"]
  end

  def find_percentile_enjoyment
    scores.each do |key, value|
      value.each do |k, v|
          scores[key][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if key == :enjoyment_score
          scores[key][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:big_five_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if key == :big_five_score
          scores[key][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if k == :category_3 && key == :enjoyment_score
          scores[key][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:big_five_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if k == :category_3 && key == :big_five_score
      end
    end
  end

  def difference_between(v1, v2)
   (v1-v2)/((v1+v2)/2) * 100
  end

end
