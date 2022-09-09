"keyrir startup...".postln;

o = Server.local.options;
o.memSize = 2.pow(16);
("memory:" + o.memSize).postln;
s.options.blockSize = 16;
("blockSize:" + s.options.blockSize).postln;
// s.options.maxSynthDefs_(10000);


s.options.numAudioBusChannels = max(s.options.numAudioBusChannels, 8192);
s.options.numControlBusChannels = max(s.options.numControlBusChannels, 16384);
s.options.numBuffers = max(s.options.numBuffers, 8192);
s.options.maxNodes = max(s.options.maxNodes, 8192);
s.options.maxSynthDefs = max(8192, s.options.maxSynthDefs);
s.options.numWireBufs = max(1024, s.options.numWireBufs);

[
  "/home/gulli/github/supercollider/dagar/note_parser.scd",
  "/home/gulli/github/supercollider/dagar/routine_utils.scd",
].do { |file|
  file.load;
};

"startup búið!".postln;
