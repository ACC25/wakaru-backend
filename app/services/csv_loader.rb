require 'csv'

class CsvLoader
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def load_tone_baseline
    responses = []
    question = ""
    CSV.foreach(path) do |row|
      if row[0] != "Timestamp" && public_response_profane?(row[1]) == false
        responses << ToneResponse.new(question, row[1])
      elsif row[0] == "Timestamp"
        question = row[1]
      end
    end
    responses
  end

  private

  def public_response_profane?(text)
    Obscenity.profane?(text)
  end

end
