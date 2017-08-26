require 'tempfile'
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
    JSON.parse(response.body, symbolize_names: true)
  end

  def analyze_tone_chat(tone_chat_input)
    # File.open("tone_chat/temp.json","w") do |file|
    #   file.write(JSON.pretty_generate(tone_chat_input))
    # end
    # conn.request :multipart
    # conn.response :logger
    # conn.adapter :net_http
    conn.basic_auth("#{ENV['watson_tone_username']}", "#{ENV['watson_tone_password']}")
    response = conn.get("/tone-analyzer/api/v3/tone_chat") do |request|
      request.params['Content-Type'] = "application/json"
      request.params['body'] = tone_chat_input.to_json
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
