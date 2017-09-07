class Statistic
  attr_reader :db,
              :scores,
              :comments

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
      }
    }
    @comments = {
      enjoyment: [],
      brand: []
    }
  end

  def find_my_category
    find_percentile_ranks
  end

  def create_suggestions
    comments.each_pair do |k, v|
      k == :enjoyment ? comments[k] = query_enjoyment_words : comments[k] = query_brand_words
    end
  end

  private

  def query_enjoyment_words
    above_average = ["pleasant", "above-average"]
    best = []
    below_average = []
    worst = []
    output = []
    if scores[:enjoyment_score][:category_0] >= 50.0
      "A customers experience with this email is likely #{good_words.sample}"
    elsif scores
    end
  end

  def query_brand_words
    bad_words = ["poor", "below-average"]
  end

  def find_percentile_ranks
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
