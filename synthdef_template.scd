(SynthDef(
	\test,
	{
		|freq = 440|
		Out.ar(0,
			x = SinOsc.ar(freq=freq);
			x!2;
		)
	}
).add;)

Synth(\test);
Synth(\test, [\freq, 220]);

x = Synth(\test);
x.set(\freq, 220);
x.free;
