"keyrir startup...".postln;

o = Server.local.options;
o.memSize = 2.pow(16);
("memory:" + o.memSize).postln;
s.options.blockSize = 16;
("blockSize:" + s.options.blockSize).postln;
s.options.maxSynthDefs_(10000);

"startup búið!".postln;
