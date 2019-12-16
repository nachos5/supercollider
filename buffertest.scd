s.boot;
a=LFCub;play{RecordBuf.ar(InFeedback.ar+a.ar(99),b=Buffer.alloc(s,8e4));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1.5,0,3)}
b = Buffer.alloc(s, 44100 * 4, 1);

// sínusbylgja í buffer
(SynthDef(
	\test,
	{
		arg freq = 440, sek = 4.0;
		var playbuf;
		x = SinOsc.ar(freq=freq)!2;
		RecordBuf.ar(x, b);
		playbuf = PlayBuf.ar(2, b);
		FreeSelfWhenDone.kr(playbuf);
		Out.ar(0, playbuf)!2;
	}
).play;)

Synth(\test);
Synth(\test, [\freq, 220]);


(SynthDef(
	\test2,
	{
		arg freq = 220, sek = 4.0;
		var playbuf, grains;
		x = InFeedback.ar + LFCub.ar(freq=freq);
		RecordBuf.ar(x, b);
		playbuf = PlayBuf.ar(1, b);
		//FreeSelfWhenDone.kr(playbuf);
		grains = TGrains.ar(2, LFCub ar:c=[3,2],b,LFCub.ar(1/c)>0/2+1.5,0,3);
		Out.ar(0, grains);
	}
).play;)

Synth(\test2);
Synth(\test2, [\freq, 110]);
Synth(\test2, [\freq, 220]);

// **** BUS DÓT **** //

~delay = Bus.audio(s, 2);
~mod = Bus.audio(s, 2);
~gate = Bus.audio(s, 2);
~k5 = Bus.control;

~controlSyn = {Out.kr(~k5, LFNoise0.kr(4))}.play;

(~delaySyn = {
	Out.ar(0,
		AllpassC.ar(
			In.ar(~delay, 2), 2, [0.65, 1.15], 10)
	)
}.play(~controlSyn, addAction: \addAfter);)

(~modSyn = {
	Out.ar(~delay,
		In.ar(~mod, 2) * SinOsc.ar(In.kr(~k5)*500 + 1100)
	)
}.play(~delaySyn, addAction: \addBefore);)

(~gateSyn = {
	Out.ar([0, ~mod],
		In.ar(~gate, 2) * max(0, In.kr(~k5))
	)
}.play(~modSyn, addAction: \addBefore);)

~pbGroup = Group.before(~controlSyn);

{Out.ar(~gate, SinOsc.ar() * 0.2)}.play(~pbGroup);
{Out.ar(~gate, SinOsc.ar(220) * 0.2)}.play(~pbGroup);



~controlbus = Bus.control(s, 2);

(SynthDef(
	\audio,
	{
		arg bus, freqOffset;
		x = SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5);
		Out.ar(0, x!2);
	}
).add)

(SynthDef(
	\control,
	{
		arg bus;
		x = SinOsc.kr(1, 0, 100, 100);
		Out.kr(bus, x);
	}
).add)

Synth(\control, [\bus, ~controlbus])
Synth(\audio, [\bus, ~controlbus, \freqOffset, 200])
