require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }.join
  end


  def score
    words = params[:word]
    word_to_char = words.upcase.chars
    answer = URI.open("https://wagon-dictionary.herokuapp.com/#{words}").read
    output = JSON.parse(answer)
    generate = params[:letters].chars.join(', ')

    if output['found'] == true && word_checker(word_to_char, generate)
      @outcome = "<b>Congratulation!</b> #{words.upcase} is a valid English word!".html_safe
    elsif word_checker(word_to_char, generate) == false
      @outcome = "Sorry but <b>#{words.upcase}</b> can't be built out of #{generate}".html_safe
    else
      @outcome = "Sorry but <b>#{words.upcase}</b> does not seem to be a valid English word...".html_safe
    end
  end

  def word_checker(word_to_char, generate)
    check = true
    word_to_char.each do |letter|
      check = false unless generate.include? letter
      check = false unless word_to_char.count(letter) <= generate.count(letter)
    end
  return check
  end
end
