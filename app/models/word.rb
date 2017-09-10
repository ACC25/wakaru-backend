class Word
  attr_reader :category,
              :text_collection,
              :reader,
              :top_words

  def initialize(text_collection)
    @text_collection = text_collection
    @reader = EngTagger.new
    @top_words = {
      nouns: "",
      adjectives: "",
      keywords: ""
    }
  end

  def find_words
    find_nouns
    find_adjectives
    find_keywords
  end

  private

  def find_keywords
    set_keyword_settings
  end

  def set_keyword_settings
    text_collection.each do |response|
      text = Highscore::Content.new response
      text.configure do
        set :multiplier, 2
        set :upper_case, 3
        set :long_words, 2
        set :long_words_threshold, 15
        set :short_words_threshold, 3
        set :bonus_multiplier, 2
        set :vowels, 1
        set :consonants, 5
        set :ignore_case, true
        set :word_pattern, /[\w]+[^\s0-9]/
        set :stemming, true
      end
      keywords = text.keywords.top(50).each do |keyword|
        keyword.text
        keyword.weight
      end
      find_top_keywords(keywords)
    end
  end

  def find_top_keywords(keywords)
    range = keywords.map(&:weight)
    keywords.map! do |keyword|
      keyword if range.extend(DescriptiveStatistics).percentile_rank(keyword.weight) > 80.0
    end
    keywords.reject! { |item| item.blank? }
    set_top_keywords(keywords)
  end

  def set_top_keywords(keywords)
    words = keywords[0...10].map(&:text)
    top_words[:keywords] = words
  end

  def find_nouns
    top_nouns = find_top_nouns
    combined_nouns = flatten_words(top_nouns)
    top_words[:nouns] = rank_words(combined_nouns)[0...10]
  end

  def find_adjectives
    top_adjectives = find_top_adjectives
    combined_adjectives = flatten_words(top_adjectives)
    top_words[:adjectives] = rank_words(combined_adjectives)[0...10]
  end

  def find_top_adjectives
    text_collection.map do |text|
      tagged = reader.add_tags(text)
      reader.get_adjectives(tagged)
    end
  end

  def find_top_nouns
    text_collection.map do |text|
      tagged = reader.add_tags(text)
      reader.get_nouns(tagged)
    end
  end

  def flatten_words(collection)
    output = {}
    collection.each do |words|
      words.each_pair do |k, v|
      output[k] == nil ? output[k] = v : output[k] += v
      end
    end
    output
  end

  def rank_words(words)
    forbidden_words = %w[Hi hi Customer customer]
    output = words.sort_by{ |k, v| v }.map do |words|
      if forbidden_words.include?(words[0]) == false
         words[0]
      end
    end
    output.reject { |item| item.blank? }
  end

end
