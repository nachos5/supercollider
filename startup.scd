"keyrir startup...".postln;

// Server.supernova;

s.latency = 0.3;
s.options.sampleRate = s.options.sampleRate ? 44100;
s.options.hardwareBufferSize = s.options.hardwareBufferSize ? 256;
s.options.blockSize = 16;
s.options.memSize = max(s.options.memSize, 8192 * 16 * 16);
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

// scnvim
if (\SCNvim.asClass.notNil) {
    Server.default.doWhenBooted {
        \SCNvim.asClass.updateStatusLine(1, \SCNvim.asClass.port);
    }
};

"startup búið!".postln;
