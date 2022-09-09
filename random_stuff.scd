Server.killAll
SCDoc.helpTargetDir

// volume dót
(
v = s.volume;
v.setVolumeRange(-90, -40);
v.volume = -80;
)

s.volume.volume;

(
s.queryAllNodes;
)

// 'path' dót
Platform.userConfigDir
Platform.userExtensionDir;
Platform.systemExtensionDir;
c = MyClass();
c.instanceMethod();

rand(100);
exprand(1.0, 100.0); // lægri value líklegri
dup("echo", 20);

round([1.234, 525.222], 0.01);
sort([9,8,7]);
[0, 2, 4, 5, 6, 7, 9, 11].scramble;
[60, 62, 64, 67, 69].mirror;
[1, 2, 3, 4, 5, 6, 7, 8, 10, 11].rotate;
[60, 62, 64, 65, 67, 69, 71].mipicps.round(0.1); // midi to Hz
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].permute(9);

x = {SinOsc.ar(440)!2 * 0.2};
x.postln;
x.play;
x.plot;
x.scope;

{Blip.ar(50, LFNoise0.kr([3, 4], 12, 14), 0.3)}.play

v = "4";
v.asInteger;

"með" + "bili";
"ekki með " ++ "bili";

~global = "pog";
~global.postln;
