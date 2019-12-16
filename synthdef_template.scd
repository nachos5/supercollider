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


(SynthDef(
	\mixnew,
	{
		a = [
			SinOsc.ar(110),
			SinOsc.ar(220),
			SinOsc.ar(330),
			SinOsc.ar(440)
		];
		x = Mix.new(a);
		Out.ar(0, x!2);
	}
).add;)

Synth(\mixnew);

(SynthDef(
	\mixfill,
	{
		arg count = 0;
		var n = 4;
		count.postln;
		x = Mix.fill(n, {
			SinOsc.ar([110, 220, 440].choose);
		});
		x = SinOsc.ar(count);
		Out.ar(0, x!2);
	}
).add.play;)