require "open-uri"

class GamesController < ApplicationController
  VOWELS = ["a", "e", "i", "o", "u"]
  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('a'..'z').to_a - VOWELS).sample }
    @letters.shuffle!
    @time = Time.now
  end

  def score
    @start_time = params[:time].to_i
    @end_time = Time.now.to_i
    @time_length = @end_time - @start_time
    @user_answer = params[:answer]
    @random_letters = params[:random_letters]
    @included = included?
    @english_word = english_word?
    @score = (1 / @time_length.to_f) * @user_answer.length
  end

  private

  def included?
    @user_answer.chars.all? { |letter| @user_answer.count(letter) <= @random_letters.count(letter) }
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{user_answer}"
    result = JSON.parse(open(url).read)
  end

end
