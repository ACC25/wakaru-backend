class Statistic
  include ActiveModel::Serialization

  attr_reader :db,
              :scores,
              :overall_score

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
  end

  def find_my_category
    find_percentile_enjoyment
    find_percentile_dissastisfaction
    findings = find_overall_score
    summary = interpret_findings(findings)
    determine_overall_entertainment(summary)
    determine_overall_brand(summary)
  end


  private

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
      scores[:dissatisfaction_score][k] = Response.where(category: k.to_s.split("_")[1]).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score)
      scores[:dissatisfaction_score][k] = Response.where(category: 0).or(Response.where(category: 1)).pluck(:dissatisfaction_score).extend(DescriptiveStatistics).percentile_rank(db.dissatisfaction_score) if k == :category_3
    end
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
    elsif summary[:enjoyment_score] == "high" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone of this email is positive and agreeable."
    elsif summary[:enjoyment_score] == "high" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone is good, but declining agreeableness."
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "high"
      overall_score[:enjoyment] = "Overall tone could be improved with small changes."
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone could be improved with small changes."
    elsif summary[:enjoyment_score] == "medium" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone uncertain. Recommend re-write."
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "high"
      overall_score[:enjoyment] = "Overall tone is negative. Recommend re-write."
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "medium"
      overall_score[:enjoyment] = "Overall tone is negative and unwarranted."
    elsif summary[:enjoyment_score] == "low" && summary[:big_five_score] == "low"
      overall_score[:enjoyment] = "Overall tone is unprofessional."
    end
  end

  def determine_overall_brand(summary)
    if summary[:dissatisfaction_score] == "high" && summary[:enjoyment_score] == "high"
      overall_score[:brand] = "Great brand representation."
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
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Brand likely suffered from interaction."
    elsif summary[:dissatisfaction_score] == "low" && summary[:enjoyment_score] == "medium"
      overall_score[:brand] = "Brand suffered from interaction."
    end
  end
end
