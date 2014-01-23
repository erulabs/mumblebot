require 'rubygems'
require 'oauth'
require 'json'

# Consumer key + access token stuff
# Requires read/write access in twitter settings
module TwitterMod
	class MumbleTweets
		def send_tweet(mumble_text)
			consumer_key = OAuth::Consumer.new(
		  	"n9RePi7BTceP9GHVY26Rfg",
		  	"TqpuSciBd40DJpuLIn1WSDY7HnzMGkmQPMmhIUVrpY")
			access_token = OAuth::Token.new(
		  	"1712060150-8e9AKWphu2ait1dM0APOBZwW04fAIwN3uAmDfub",
		  	"XahroDPBTGEKyrWHxqTHUXazYxlBqxa2Xqhkyy6CY")


			baseurl = "https://api.twitter.com"
			path    = "/1.1/statuses/update.json"
			address = URI("#{baseurl}#{path}")
			request = Net::HTTP::Post.new address.request_uri
			request.set_form_data(
		  	"status" => "#{mumble_text}", #THIS IS WHERE THE STATUS TEXT GOES OMG
			)

			# Set up HTTP.
			http             = Net::HTTP.new address.host, address.port
			http.use_ssl     = true
			http.verify_mode = OpenSSL::SSL::VERIFY_PEER

			# Issue the request.
			request.oauth! http, consumer_key, access_token
			http.start
			response = http.request request

			# Parse and print the Tweet if the response code was 200
			tweet = nil
			if response.code == '200' then
			  tweet = JSON.parse(response.body)
			  puts "Successfully sent #{tweet["text"]}"
			else
			  puts "Could not send the Tweet! " +
			  "Code:#{response.code} Body:#{response.body}"
			end
		end

		def test_thing
			send "test"
		end
	end
end
