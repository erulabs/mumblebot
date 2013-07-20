mumblebot
=========

a bot for the mumble by the Gt/Erulabs crew


How to make proper soundboard files:
====================================

1. Place mp3 files into /mumblebot/audio
2. Using mpg123, use the following command "mpg123 -r48000 -m -s FILENAME.mp3 > FILENAME.fifo" where FILENAME is the name of the mp3 file you're converting. The -r48000 ensures that it's converted to 48000Hz
3. You now have a file in /mumblebot/audio called FILENAME.fifo
4. Don't forget to "rm FILENAME.mp3" to delete the original .mp3 file to save space!
5. Calling /sb FILENAME (no .mp3 extension here) should now play your sound file in mumble!
