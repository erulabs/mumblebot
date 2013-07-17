#!/usr/bin/ruby

require 'mumble-ruby'
require 'net/https'
require 'uri'
require 'json'
require 'base64'
require 'open-uri'

class MambleBot

	def log(msg)
		File.open('/var/log/murmur/mumble.log', 'a') { |file| file.write(msg+"\n") }
	end

	def send(msg)
		log 'Mumblebot: '+msg
		@cli.text_channel @cli.current_channel.name, msg
	end
	
	def encodeImage(url)
		#return Base64.encode64(url)
		imagedata = open(url) { |io| io.read }
		#puts imagedata
		send "<img src='data:image/PNG;base64," + Base64.encode64(imagedata) + "'>"
	end

	def listen_commands(msg)
		case msg
		when /pug\s?me/
			send get_pug()
		end
	end
	
	def roll_dice(d)
		send Random.rand(1...d.to_i).to_s
	end
	
	def get_pug()
		uri = URI.parse("http://pugme.herokuapp.com/random")
		imageurl = JSON.parse(Net::HTTP.get_response(uri).body)["pug"]
		#encoded = encodeImage(imageurl)
		#send encoded
		send "<a href='"+imageurl+"'>pug</a>"
	end

	def get_image(url)
		send encodeImage("https://i2.wp.com/a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-user-420.png")
	end

	def initialize
		@cli = Mumble::Client.new('erulabs.com', 64738, 'MambleBot', 'qweasd')
		@cli.on_text_message do |msg|
			if @cli.users.has_key?(msg.actor)
				log @cli.users[msg.actor].name + ": " + msg.message
				case msg.message.to_s
				when /^(?:[\/\\]|)d(\d{1,3})$/
					send roll_dice($1)
				when /^m[au]mblebot/
					listen_commands($')
				when /^img/
					get_image($')
				when /spot the fed/i
					send "NOT MUMBLEBOT. NOT MUMBLEBOT AT ALL. I didn't just log that you said #{msg.message.to_s} at all.. >_>;;. Nobody is listening."
				end
			end
		end
		@cli.connect
		@cli.mute
		@cli.deafen
		sleep(1)
		@cli.join_channel('peench peench')
		puts 'Press enter to terminate script';
		gets
		@cli.disconnect
	end
end

bot = MambleBot.new()
