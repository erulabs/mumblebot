require 'rubygems'
require 'bundler/setup'

require 'mumble-ruby'
require 'net/https'
require 'uri'
require 'json'
require 'base64'
require 'open-uri'
require 'debugger'

class MambleBot

	NAME = "puppydoge"

	def subscribe(regex, &block)
		regex = Regexp.new(regex.inspect.sub('/', "/#{MambleBot::NAME}\\s?")[1..-2]) unless regex.inspect =~ /^\/\\\//
		@subs[regex] = block
	end

	alias_method :sub, :subscribe

	def fire_commands(command)
		puts "attempting to fire a command, '#{command}'"
		@subs.select{|key| command =~ key}.each do |k,v|
			v.call(*((Regexp.last_match[1..-1].to_a << $').compact.reject(&:empty?)))
		end
	end


	def log(msg)
		File.open('mumble.log', 'a') { |file| file.write(msg+"\n") }
	end

	def send(msg)
		log 'Falconbot: '+msg
		@cli.text_channel @cli.current_channel.name, msg
	end
	
	def encodeImage(url)
		#return Base64.encode64(url)
		imagedata = open(url) { |io| io.read }
	#	puts imagedata
		return "<img src='data:image/*;base64," + Base64.encode64(imagedata) + "' \\>"
	end

#	def find_falcon
#		
#	end

	def listen_commands(msg)
		derp = msg.strip.to_s
		puts "DEBUG: find_channel's #{derp} class is #{@cli.find_channel.class}"	
	end

	def channel_commands(name)
		name = name.strip.to_s
		@cli.join_channel(name)
		sleep(1)
	end

	def sound_board(msg)
		msg ||= ''
		msg = msg.strip
		file =	File.join('audio/',"#{msg}.fifo")
		@cli.stream_raw_audio(file) if File.exist? file
		sleep(1)
		send "Available sounds: 007, bananas, calmtits, camera, csbro, dawg, eru, ftt, fwiz, hello, hg1, hg2, heyguys, kkk, lollipop, omg, pants, upcarrot, vg, words, wow." if msg == ""
	end
			
	
	def roll_dice(d)
		if d != "1"
			return Random.rand(1...d.to_i).to_s 
		else
			return "nope!"
		end

	end
	
	def get_pug()
		uri = URI.parse("http://pugme.herokuapp.com/random")
		imageurl = JSON.parse(Net::HTTP.get_response(uri).body)["pug"]
		if Net::HTTP.get_response(URI.parse(JSON.parse(Net::HTTP.get_response(uri).body)["pug"])).body !~ /\<HTML\>/i
			puts "encoding!!!"
			send imageurl
			encoded = encodeImage(imageurl)
			return encoded
		else
			return "<a href='"+imageurl+"'>pug</a>"
		end
	end

	def get_image(url)
	#	send encodeImage("http://i2.wp.com/a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-user-420.png")
		#send encodeImage("http://images.wikia.com/jamescameronsavatar/images/1/13/Awesome.png")
	#	send encodeImage("http://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/PNG_transparency_demonstration_2.png/280px-PNG_transparency_demonstration_2.png")
		url = url.match(/\<.*\>(.*)\<.*\>/)[1]
		puts url
		send encodeImage(url)
	end


	def initialize
		@subs ={}
		subscribe /\/sb/ do |msg|
			sound_board msg
		end
		subscribe /play/ do |msg|
			sound_board msg
		end
		@cli = Mumble::Client.new('erulabs.com', 64738, MambleBot::NAME, 'qweasd')
		@cli.on_text_message do |msg|
			if @cli.users.has_key?(msg.actor)
				log @cli.users[msg.actor].name + ": " + msg.message
			        fire_commands msg.message.to_s
				case msg.message.to_s
				when /^(?:[\/\\]|)d(\d{1,3})$/
					send roll_dice($1)
				when /^\/channel/
					channel_commands($')
				when /^\/fb/
					puts "Herp Derp #{@cli.find_user($').to_s}"
				#when /^\/sb/
				#	sound_board($')
				when /^img/
					get_image($')
				when /^msg/ then send($') 
				when /spot the fed/i
					send "NOT MUMBLEBOT. NOT MUMBLEBOT AT ALL. I didn't just log that you said #{msg.message.to_s} at all.. >_>;;. Nobody is listening."
				end
			end
		end
		@cli.connect
		#@cli.mute
		#@cli.deafen
		sleep(1)
		@cli.join_channel('Root')
		puts 'Press enter to terminate script';
		gets
		@cli.disconnect
	end
end

bot = MambleBot.new()
