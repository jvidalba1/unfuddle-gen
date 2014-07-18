require 'rubygems'
require 'httparty'

puts "primer bloque..."
# Use the class methods to get down to business quickly
# response = HTTParty.get('http://twitter.com/statuses/public_timeline.json')
# puts response.body

# response.each do |item|
#   puts item['user']['screen_name']
# end

# Or wrap things up in your own class
class Twitter
  include HTTParty
  base_uri 'twitter.com'

  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  # which can be :friends, :user or :public
  # options[:query] can be things like since, since_id, count, etc.
  def timeline(which=:friends, options={})
    options.merge!({:basic_auth => @auth})
    self.class.get("/statuses/#{which}_timeline.json", options)
  end

  def post(text)
    options = { :body => {:status => text}, :basic_auth => @auth }
    self.class.post('/statuses/update.json', options)
  end
end

twitter = Twitter.new("jvidalba", "vrpRMB96")
p twitter.timeline