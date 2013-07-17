#Until I figure out how to interpolate into single quotes, this will have to do
def sound_board(msg)
	case msg
	when list
		send "Available Sounds: 007, bananas, calmtits, camera, csbro, dawg, eru, fwizard, hello, heyguys, kkk, lollipop, omg, pants, upcarrot, words, wow."
	when 007
		@cli.stream_raw_audio('audio/007.fifo')
	when bananas
		@cli.stream_raw_audio('audio/bananas.fifo')
	when calmtits
		@cli.stream_raw_audio('audio/calmtits.fifo')
	when camera
		@cli.stream_raw_audio('audio/camera.fifo')
	when csbro
		@cli.stream_raw_audio('audio/csbro.fifo')
	when dawg
		@cli.stream_raw_audio('audio/dawg.fifo')
	when eru
		@cli.stream_raw_audio('audio/eru.fifo')
	when fwizard
		@cli.stream_raw_audio('audio/fwizard.fifo')
	when hello
		@cli.stream_raw_audio('audio/hello.fifo')
	when heyguys
		@cli.stream_raw_audio('audio/heyguys.fifo')
	when kkk
		@cli.stream_raw_audio('audio/kkk.fifo')
	when lollipop
		@cli.stream_raw_audio('audio/lollipop.fifo')
	when omg
		@cli.stream_raw_audio('audio/omg.fifo')
	when pants
		@cli.stream_raw_audio('audio/pants.fifo')
	when upcarrot
		@cli.stream_raw_audio('audio/upcarrot.fifo')
	when words
		@cli.stream_raw_audio('audio/words.fifo')
	when wow
		@cli.stream_raw_audio('audio/wow.fifo')
	end
end		
