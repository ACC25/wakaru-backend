class Calculator

  def average_base_tone(domain, column)
    BaseResponse.where(domain: domain).average(column.to_sym)
  end

  def overall_average_base_tone(domain)

  end

end
