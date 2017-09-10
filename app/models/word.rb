class Word
  attr_reader :category,
              :text_collection,
              :reader,
              :top_words

  def initialize(category, text_collection)
    @wcategory = category
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
