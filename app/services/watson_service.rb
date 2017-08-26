class WatsonService
  attr_reader :text

  def initialize(user = nil, string)
    @user = user
    @text = string
    @conn = Faraday.new(:url => 'https://gateway.watsonplatform.net')
  end

  def analyze_tone
    url_string = url_encode(text)
    conn.basic_auth("#{ENV['watson_tone_username']}", "#{ENV['watson_tone_password']}")
    response = conn.get("/tone-analyzer/api/v3/tone") do |request|
      request.params['Content-Type'] = "application/json"
      request.params['text'] = url_encode(@text)
      request.params['version'] = "2017-08-25"
    end
    output = JSON.parse(response.body, symbolize_names: true)
  end


  private

  attr_reader :conn

  def url_encode(string)
    ERB::Util.url_encode(string)
  end

end
