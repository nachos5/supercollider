(
~asset_test = "/media/gulli/Gulli/samples/Deadmau5 Samplepack/Snares/Layered/XF_SnrLayer24.wav";
// 6, 18, 24

~assets_folder = "/home/gulli/github/supercollider/projects/assets";
~ping_pong_buffer = Buffer.alloc(s, 44100 * 2, 2);
~vocal = Buffer.read(s, ~assets_folder ++ "/raddir/female-vocal-long.wav");
~kick = Buffer.read(s, ~assets_folder ++ "/trommur/VEH3 Kicks 015.wav");
~kick_2 = Buffer.read(s, ~assets_folder ++ "/trommur/kick_1.wav");
~snare = Buffer.read(s, ~assets_folder ++ "/trommur/XF_SnrLayer24.wav");

)

// {PlayBuf.ar(1, ~vocal)}.play;
// ~vocal.numChannels;
// ~kick.numChannels;
// Synth(\kick);
// Synth(\snare);
