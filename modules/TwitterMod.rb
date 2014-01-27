module TwitterMod
	require 'rubygems'
	require 'oauth'
	require 'json'
	# Consumber Keys / Access Token
	consumer_key = OAuth::Consumer.new(
	  "i5tDgLrcIZCPsjOthnFERQ",
	  "Y7J5wbSpQvNJnPkYpe4Gr65Qxp7NaOPV7GQBwhvI4")
	access_token = OAuth::Token.new(
	  "308601364-iB6x9Is6YzkNb8Dq6abqvYwy1zBzy73XM97Yr76R",
	  "zjU2MiUBHIMvpMJhG36JAjSzNdtv1WW3nw37N6aToU")


	baseurl = "https://api.twitter.com"
	path    = "/1.1/statuses/update.json"
	address = URI("#{baseurl}#{path}")
	request = Net::HTTP::Post.new address.request_uri
	# INPUT TWEET TEXT RIGHT BELOW! :D
	request.set_form_data(
	  "status" => "Just doing some Ruby Twitter API stuff, no biggie ;D",
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