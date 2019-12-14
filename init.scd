s.boot;

(
o = Server.local.options;
o.numOutputBusChannels.postln;
o.memSize.postln;
o.memSize = 2.pow(16);
o.memSize.postln;
)

(
s.quit;
s.boot;
)

// volume dót
(
v = s.volume;
v.setVolumeRange(-90, 0);
)