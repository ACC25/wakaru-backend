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
    uri = URI.parse("https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone_chat?version=2017-08-25")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("#{ENV['watson_tone_username']}", "#{ENV['watson_tone_password']}")
    request.content_type = "application/json"
    request.body = tone_chat_input.to_json
    # request.body << File.read("tone_chat/temp.json").delete("\r\n")
    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    JSON.parse(response.body, symbolize_names: true)
  end


  private

  attr_reader :conn

  def url_encode(string)
    ERB::Util.url_encode(string)
  end

end
