require_relative "./api"
require "simple_oauth"

api = Twitter::Api.new
keyword = ARGV.first

ruby_tweet = api.get_user_timeline.find do |tweet|
  tweet.text.include?(keyword)
end || api.search(keyword).first

if ruby_tweet
  puts "Gotcha!"
  puts ruby_tweet.text
else
  puts "We searched in your timeline and in the world for #{keyword} and we didn't find nothing :("
end
