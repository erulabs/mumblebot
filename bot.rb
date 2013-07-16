#!/usr/bin/ruby

require 'mumble-ruby'
require 'net/https'
require 'uri'
require 'json'

class MambleBot

	def send(msg)
		@cli.text_channel @cli.current_channel.name, msg
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
		return JSON.parse(Net::HTTP.get_response(uri).body)["pug"]
	end

	def initialize
		@cli = Mumble::Client.new('erulabs.com', 64738, 'MambleBot', 'qweasd')
		@cli.on_text_message do |msg|
			if @cli.users.has_key?(msg.actor)
				logmsg = @cli.users[msg.actor].name + ": " + msg.message
				File.open('/var/log/murmur/mumble.log', 'a') { |file| file.write(logmsg+"\n") }
				case msg.message.to_s
				when /^\/d(\d{3})$/
					send roll_dice($1)
				when /^m[au]mblebot/
					listen_commands($`)
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
