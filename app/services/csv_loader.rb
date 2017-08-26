require 'csv'

class CsvLoader
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def load_tone_baseline
    responses = []
    CSV.foreach(path) do |row|
      if row[0] != "Timestamp"
        responses << ToneResponse.new(row[1])
      end
    end
    responses
  end

  def load_tone_chat_baseline
  end

end
