b = Buffer.alloc(s, 44100 * 4, 1);

(SynthDef(
	\amb1,
	{
		arg freq = 220;
		var playbuf, grains;
		x = InFeedback.ar + LFCub.ar(freq=freq);
		RecordBuf.ar(x, b);
		playbuf = PlayBuf.ar(1, b);
		grains = TGrains.ar(2, LFCub ar:c=[3,2], b, LFCub.ar(1/c)>0/2+1.5, 0, 3);
		Out.ar(0, grains * 0.2);
	}
).add;)

(SynthDef(
	\kick,
	{
		x = SinOsc.ar(40);
		x = x * Pulse.ar(2);
		Out.ar(1, x!2);
	}
).add;)

(SynthDef(
	\tri,
	{
		x = LFTri.ar(220).tanh(1.9) * 0.3;
		// x = GVerb.ar(x, 20, 9, mul: 0.33).cubed;
		Out.ar(0, x!2);
	}
).add;)

(
Synth(\amb1, [\freq, 53.midicps]); // f3
Synth(\amb1, [\freq, 60.midicps]); // c4
Synth(\amb1, [\freq, 69.midicps]); // a4

Synth(\kick);
Synth(\tri);
)