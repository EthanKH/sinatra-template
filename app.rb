require "sinatra"
require "sinatra/reloader"
require "http"
require "net/http"
require 'json'
require 'erb'

require "better_errors"
require "binding_of_caller"

use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

@winners = []
@losers =[]

get("/") do
  erb(:start)
end

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
  else
    # Handle cases where the response format is unexpected
    # You can choose to retry or show an error message
  end
end

def generate_animal2
  api_urls = [
    "https://random.dog/woof.json",
    "https://randomfox.ca/floof/"
  ]
  random_api_url = api_urls.sample
  response = Net::HTTP.get(URI(random_api_url))
  data = JSON.parse(response)

  if data.key?("url")
    image_url2 = data["url"]
  elsif data.key?("image")
    image_url2 = data["image"]
  else
    # Handle cases where the response format is unexpected
    # You can choose to retry or show an error message
  end
end

get("/game") do
  image_url = generate_animal
  image_url2 = generate_animal2
  erb :game, locals: { image_url: image_url, image_url2: image_url2 }
end

get("/random") do
  image_url = generate_animal
  erb :random, locals: { image_url: image_url }
end

get("/win_lose") do
  erb (:win_lose)
end
