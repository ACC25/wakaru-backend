class Calculator

  def average_base_tone(domain, column)
    BaseResponse.where(domain: domain).average(column.to_sym)
  end

  def geometric_mean_base_tones(domain, category)
    binding.pry
  end

end
