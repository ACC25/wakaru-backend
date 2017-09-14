class Statistic
  include ActiveModel::Serialization

  attr_reader :db,
              :scores,
              :overall_score

  def initialize(id = nil)
    @db ||= Response.find(id) if id
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
      brand: "",
      category: ""
    }
  end

  def find_my_stats
    find_percentile_enjoyment
    find_percentile_dissastisfaction
    set_category(db.category)
  end

  def find_my_category
    find_percentile_enjoyment
    find_percentile_dissastisfaction
    findings = find_overall_score
    summary = interpret_findings(findings)
    determine_overall_entertainment(summary)
    determine_overall_brand(summary)
  end

  def categories_breakdown
    categories = [0, 1, 2]
    categories_breakdown = Response.pluck(:category)
    categories.map do |category|
      hash = {x: "", y: ""}
      category_map = {Good: 0, Medium: 1, Bad: 2}
      count = categories_breakdown.count(category).to_f
      percentage = ((count / categories_breakdown.length) * 100).round(3)
      key = category_map.key(category).to_s
      hash[:x] = key
      hash[:y] = percentage
      hash
    end
  end

  private

  def set_category(number)
    categories = ["good", "moderate", "bad"]
    db.update!(category: number) if db.domain == 0
    overall_score[:category] = categories[number]
  end

  def interpret_findings(findings)
    summarizations = {}
    findings.each_pair do |category|
      summarizations[category[0]] = summarize_findings(category[1])
    end
    summarizations
  end

  def find_overall_score
    determinations = {}
    scores.each_pair do |category, value|
      determinations[category] = []
      scores[category].map do |metric|
        determinations[category].push(low_medium_high(metric[1]))
      end
    end
    determinations
  end

  def low_medium_high(number)
    if number >= 75.0
      "high"
    elsif number >= 45.0 && number <= 75.0
      "medium"
    elsif number <= 45.0
      "low"
    end
  end

  def find_percentile_dissastisfaction
    scores[:dissatisfaction_score].each do |k, v|
      scores[:dissatisfaction_score][k] = Response.where(category: k.to_s.split("_")[1], company_id: db.company_id).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score)
      scores[:dissatisfaction_score][k] = Response.where(category: 0, company_id: db.company_id).or(Response.where(category: 1, company_id: db.company_id)).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score) if k == :category_3
    end
  end

  def find_percentile_enjoyment
    scores.each do |key, value|
      value.each do |k, v|
          scores[key][k] = Response.where(category: k.to_s.split("_")[1], company_id: db.company_id).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if key == :enjoyment_score
          scores[key][k] = Response.where(category: k.to_s.split("_")[1], company_id: db.company_id).pluck(:big_five_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if key == :big_five_score
          scores[key][k] = Response.where(category: 0, company_id: db.company_id).or(Response.where(category: 1, company_id: db.company_id)).pluck(:enjoyment_score).extend(DescriptiveStatistics).percentile_rank(db.enjoyment_score) if k == :category_3 && key == :enjoyment_score
          scores[key][k] = Response.where(category: 0, company_id: db.company_id).or(Response.where(category: 1, company_id: db.company_id)).pluck(:big_five_score).extend(DescriptiveStatistics).percentile_rank(db.big_five_score) if k == :category_3 && key == :big_five_score
      end
    end
  end

  def difference_between(v1, v2)
   (v1-v2)/((v1+v2)/2) * 100
  end

  def summarize_findings(findings)
    if findings.count("high") == 3 && findings[2] == "high"
      "high"
    elsif findings[0] == "high" && findings[2] == "high"
      "high"
    elsif findings[0] == "medium" && findings[3] == "high"
      "high"
    elsif findings[3] == "medium" && findings.count("high") == 2
      "high"
    elsif findings.count("medium") == 3 && findings[2] == "high" || findings[2] == "medium"
      "medium"
    elsif findings[3] == "medium" && findings[2] == "medium"
      "medium"
    elsif findings[1] == "medium" && findings[3] == "medium"
      "medium"
    elsif findings[2] == "medium" && findings[0] != "high"
      "medium"
    elsif findings.count("medium") == 3 && findings[2] == "low"
      "low"
    elsif findings[2] == "low" && findings[0] == "low"
      "low"
    elsif findings[2] == "medium" && findings[3] == "low"
      "low"
    elsif findings[2] == "medium" && findings[2] == "low"
      "low"
    elsif findings[0] == "medium"
      "high"
    elsif findings[3] == "medium"
      "medium"
    elsif findings[2] == "medium"
      "medium"
    elsif findings[2] == "low"
      "low"
    elsif findings[1] == "low"
      "low"
    else
      "medium"
    end
  end

  def determine_overall_entertainment(summary)
    if summary[:enjoyment_score] == "high" && summary[:big_five_score] == "high"
      overall_score[:enjoyment] = "Overall tone of this email is positive and agreeable."
      set_category(0)
    elsif summary[:enjoyment_score] == "high" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone of this email is positive and agreeable."
      set_category(0)
    elsif summary[:enjoyment_score] == "high" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone is good, but declining agreeableness."
      set_category(1)
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "high"
      overall_score[:enjoyment] = "Overall tone could be improved with small changes."
      set_category(1)
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone could be improved with small changes."
      set_category(1)
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone uncertain. Recommend re-write."
      set_category(1)
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "high"
      overall_score[:enjoyment] = "Overall tone is negative. Recommend re-write."
      set_category(2)
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone is negative and unwarranted."
      set_category(2)
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone is unprofessional."
      set_category(2)
    end
  end

  def determine_overall_brand(summary)
    if summary[:dissatisfaction_score] == "high" && summary[:enjoyment_score] == "high"
      overall_score[:brand] = "Great brand representation."
      set_category(0)
    elsif summary[:dissatisfaction_score] == "high" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Great brand representation."
    elsif summary[:dissatisfaction_score] == "high" && summary[:enjoyment_score] == "low"
      overall_score[:brand] = "Customer will likely forget this interaction."
    elsif summary[:dissatisfaction_score] == "medium" && summary[:enjoyment_score] == "high"
      overall_score[:brand] = "Overall positive brand representation."
    elsif summary[:dissatisfaction_score] == "medium" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Overall positive brand representation."
    elsif summary[:dissatisfaction_score] == "medium" && summary[:enjoyment_score] == "low"
      overall_score[:brand] = "Customer will likely forget this interaction."
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "high"
      overall_score[:brand] = "Poor brand representation."
      set_category(2)
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Brand likely suffered from interaction."
      set_category(2)
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Brand suffered from interaction."
      set_category(2)
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "low"
      overall_score[:brand] = "Brand suffered from interaction."
      set_category(2)
    end
  end
end
