require "sinatra"
require "sinatra/reloader"
# require "http"
require "net/http"
require 'json'

require "better_errors"
require "binding_of_caller"
use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

winners = []
losers = []

get("/") do
  erb(:start)
end

# Helper methods to generate animal images
def generate_animal
  api_urls = [
    "https://random.dog/woof.json",
    "https://randomfox.ca/floof/"
  ]
  random_api_url = api_urls.sample
  response = Net::HTTP.get(URI(random_api_url))
  data = JSON.parse(response)

  if data.key?("url")
    image_url = data["url"]
  elsif data.key?("image")
    image_url = data["image"]
  end

  if image_url && image_url.downcase.end_with?(".gif") || image_url.downcase.end_with?(".mp4")
    return generate_animal
  end
  image_url


end

get("/game") do
  @image_url = generate_animal
  @image_url2 = generate_animal
  erb(:game)
end

get("/random") do
  @image_url = generate_animal
  erb(:random)
end

get '/pick_winner/:winner' do
  winner = params['winner'].to_i
  win_url = params['win']
  lose_url = params['lose']

  if winner == 1
    @winner_url = win_url
    @loser_url = lose_url
  elsif winner == 2
    @winner_url = lose_url
    @loser_url = win_url
  end
  erb(:win_lose)
end

get("/win_lose") do
  erb(:win_lose)
end
