class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses
  attr_reader   :word_with_guesses

  # Get a word from remote "random word" service
  def initialize(word=nil)
    @word              = word || self.class.get_random_word
    @guesses           = ''
    @wrong_guesses     = ''
    @word_with_guesses = @word.gsub(/./, '-')
  end

  def guess(char)
    raise ArgumentError, "Invalid guess" \
      unless char && char.instance_of?(String) && char.match(/\A[a-z]\z/i)

    char = char.downcase
    return false if @guesses.include?(char) || @wrong_guesses.include?(char)

    process_guess char
  end

  def process_guess(char)
     (word.include?(char) ? @guesses : @wrong_guesses) << char 
     update_word_with_guesses(char)
  end

  def update_word_with_guesses(char)
    indexes = (0...word.length).select { |i| word[i] == char }
    indexes.each { |i| @word_with_guesses[i] = char }
  end

  def check_win_or_lose
    return :win  if @word_with_guesses == @word
    return :lose if @wrong_guesses.size == 7
    return :play
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
