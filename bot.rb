require 'rubygems'
require 'bundler/setup'

require 'mumble-ruby'
require 'net/https'
require 'uri'
require 'json'
require 'base64'
require 'open-uri'

class MambleBot

	def log(msg)
		File.open('mumble.log', 'a') { |file| file.write(msg+"\n") }
	end

	def text_channel(msg)
		log 'Falconbot: '+msg
		@cli.text_channel @cli.current_channel.name, msg
	end
	
	def listen_commands(msg)
		derp = msg.strip.to_s
		puts "DEBUG: find_channel's #{derp} class is #{@cli.find_channel.class}"	
	end

	def change_channel(name)
		name = name.strip.to_s
		@cli.join_channel(name)
		sleep(1)
	end

	def sound_board(msg)
		msg = msg.strip
		file =	File.join('audio/',"#{msg}.fifo")
		@cli.stream_raw_audio(file) if File.exist? file
		sleep(1)
		availableFiles = Dir['audio/*.fifo'].map{|file| file.split(/[\/.]/)[1]}
		availableFiles.sort!.join(", ")
		text_channel "Available sounds: #{availableFiles}." if msg == ""
	end
			
	def roll_dice(d)
		if d != "1"
			return Random.rand(1...d.to_i).to_s 
		else
			return "nope!"
		end
	end

	def response_message(invoker, message)
		@invoker = invoker
		@message = message
		case message
		when "Hello"
		text_channel "#{message} #{invoker}!"
		when /shut up/i
		@cli.mute
		sleep(0.5)
		text_channel "Very mute, such quiet. Wow."
		sleep(1)
		when /unmute/i
		@cli.mute(false)
		sleep(0.5)
		text_channel "Such sound, very words. Wow."
		sleep(1)
		end
			
	end

	def initialize
		usernames = ['Doge']
		@cli = Mumble::Client.new('erulabs.com', 64738, usernames.sample, 'qweasd')
		@cli.on_text_message do |msg|
			if @cli.users.has_key?(msg.actor)
				log @cli.users[msg.actor].name + ": " + msg.message
				case msg.message.to_s
				when /^(?:[\/\\]|)d(\d{1,3})$/
					text_channel roll_dice($1)
				when /^\/channel/
					change_channel($')
				when /hello #{@cli.username}/i
					invoker = @cli.users[msg.actor].name
					response_message(invoker, "Hello")
				when /#{@cli.username}/i
					invoker = @cli.users[msg.actor].name
					response_message(invoker, $')
				when /^\/fb/
					puts "Herp Derp"
				when /^\/sb/
					sound_board($')
				when /^\/msg/
					text_channel($') 
				end
			end
		end
		@cli.connect
		#@cli.mute
		#@cli.deafen
		sleep(1)
		@cli.join_channel('Root')
		text_channel "#{@cli.username} Online!"
		puts 'Press enter to terminate script';
		gets
		@cli.disconnect
	end
end

bot = MambleBot.new()
