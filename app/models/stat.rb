class Stat
  attr_reader :db

  def initialize(id)
    @db ||= Response.find(id)
    @percentages = 0.10
    @es_differences = false
  end

  def find_my_category
    es_category = find_es_differences
    binding.pry
  end

  private

  def find_es_differences
    category_0 = Response.where(category: 0).average(:enjoyment_score).to_f
    category_1 = Response.where(category: 1).average(:enjoyment_score).to_f
    category_2 = Response.where(category: 2).average(:enjoyment_score).to_f
    @es_differences = [category_0, category_1, category_2].map do |avg|
      difference_between(avg, db.enjoyment_score)
    end
    min = differences.select{ |n| n > 0}.min
    differences.index(min)
  end

  def difference_between(v1, v2)
   (v1-v2)/((v1+v2)/2) * 100
  end

  def find_real_min

  end

end
