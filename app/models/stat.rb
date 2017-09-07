class Stat
  attr_reader :db,
              :scores

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
  end

  def find_my_category
    find_percentile_ranks
    binding.pry
  end

  private

  def find_percentile_ranks
    scores.each do |key, value|
      value.each do |k, v|
          scores[key][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if key == :enjoyment_score
          scores[key][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if key == :big_five_score
          scores[key][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if k == :category_3 && key == :enjoyment_score
          scores[key][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if k == :category_3 && key == :big_five_score
      end
    end
  end

  def difference_between(v1, v2)
   (v1-v2)/((v1+v2)/2) * 100
  end

end
