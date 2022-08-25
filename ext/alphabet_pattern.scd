(
SynthDef(\kick,{
	|amp=0.2|
	var sig, e;
	e = EnvGen.kr(Env.perc(0.01,0.15,1,-4),doneAction:2)**1.2;
	sig = (1*SinOsc.ar(e.linlin(0,1,55,110)))+PinkNoise.ar(1);
	sig = RLPF.ar(sig,e.linlin(0,1,220,1100),5).tanh;
	Out.ar(0,sig * e * amp!2);
}).add;
SynthDef(\snare,{|amp=0.1|
	var sig, e;
	e = EnvGen.kr(Env.new([1,0.15,0],[0.01,0.1],[\sine,-3]),doneAction:2);
	sig = WhiteNoise.ar() + (SinOsc.ar(e.linlin(0,1,110,440)) * e * 2);
	sig = BPeakEQ.ar(sig,e.linlin(0,1,880,1760),10,15).tanh;
	sig = RHPF.ar(sig,220,0.05).lag(0.00015);
	Out.ar(0,sig* amp * e!2);
}).add;
SynthDef(\hat,{|amp=0.1|
	var sig, e;
	e = EnvGen.kr(Env.perc(0.005,0.04),doneAction:2);
	sig = WhiteNoise.ar(1.5).tanh;
	sig = HPF.ar(sig,3520).lag(0.0001);
	Out.ar(0,0.5*sig* amp * e!2);
}).add;
)

(
var ptrn, map;
ptrn = "
k.. h.k
k.. h.s
ks. .ks
h.h sss
";
//remove spaces and line breaks
ptrn = ptrn.replace(" ","").replace("\n","");
map = IdentityDictionary[
    $k -> \kick,
    $s -> \snare,
	$h -> \hat,
	$. -> \rest
];
p.stop;
p = Pbind(
	\instrument, Pn(Pseries(0,1,ptrn.size)),
	\instrument, Pfunc{|key| map[ptrn[key[\instrument]]]},
	\dur,0.12,
	\amp,0.1*Pn(Pseries(1,-0.1,3)).trace,
).play;
)
