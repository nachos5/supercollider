s.freeAll;

(
~buffer = Buffer.alloc(s, 44100 * 4, 1);

~masterbus = Bus.audio(s, 2);
~reverbbus = Bus.audio(s, 2);
~bandpassbus = Bus.audio(s, 2);
~kickbus = Bus.audio(s, 2);
~sidechainbus = Bus.audio(s, 2);

~kickcontrolbus = Bus.control(s, 1);
)

({
	var ampEnv, freqEnv;
	ampEnv = EnvGen.ar(Env.perc(0.01, 0.1, 1.0), doneAction: 2);
	freqEnv = EnvGen.ar(Env([5000, 5000, 100], [0.01, 0.1]));
	n = WhiteNoise.ar();
	f = Mix(BPF.ar(n, [freqEnv, freqEnv+1000], (4..7)/10));
	f = f * ampEnv;
	Pan2.ar(f, 0);
}.play)

// **** SYNTHAR **** //
(
(SynthDef(
	\amb1,
	{
		arg bus = 0, freq = 220;
		var playbuf, grains;
		x = InFeedback.ar + SinOsc.ar(freq = freq);
		RecordBuf.ar(x, ~buffer);
		playbuf = PlayBuf.ar(1, ~buffer);
		grains = TGrains.ar(2, SinOsc ar:c=[3,2], ~buffer, SinOsc.ar(1/c)>0/2+1.5, 0, 3);
		Out.ar(bus, grains * 0.2);
	}
).add);

(SynthDef(
	\amb2,
	{
		arg bus = 0, gain = 0.05, spread = 0;
		var arr, sin, spl;
		arr = 1 / (pi..2pi);
		sin = SinOscFB.ar(arr * (700pi..705pi), 0, 0.2);
		spl = Splay.ar(sin);
		Out.ar(bus, spl * gain);
	}
).add);

(SynthDef(\kick,
	{
		arg bus = 0, pan = 0, amp = 0.3;
		var body, bodyFreq, bodyAmp;
		var pop, popFreq, popAmp;
		var click, clickAmp;
		var snd;

		// body
		bodyFreq = EnvGen.ar(Env([261, 120, 40], [0.035, 0.08], curve: \sin));
		bodyAmp = EnvGen.ar(Env.linen(0.005, 0.5, 0.3), doneAction: 2);
		body = SinOsc.ar(bodyFreq) * bodyAmp;
		// pop
		popFreq = XLine.kr(500, 261, 0.02);
		popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
		pop = SinOsc.ar(popFreq) * popAmp;
		// click
		clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
		click = LPF.ar(Formant.ar(100, 4760, 2110), 3140) * clickAmp;

		snd = body + pop + click;
		snd = snd.tanh;

		Out.ar(bus, Pan2.ar(snd, pan, amp));
	}
).add);

(SynthDef(\hat,
	{
		arg freq = 5000, pos = 0, sus = 0.1, amp = 1;
		var ampEnv, freqEnv;
		ampEnv = EnvGen.ar(Env.perc(0.01, sus, 1.0), doneAction: 2);
		freqEnv = EnvGen.ar(Env([freq, freq, 100], [0.01, 0.1]));
		n = ClipNoise.ar();
		f = Mix(BPF.ar(n, [freqEnv, freqEnv+1000], (4..7)/10));
		f = f * ampEnv;
		p = Pan2.ar(f, pos, amp);
		Out.ar(0, p);
	}
).add);


// **** EFFECTS **** //

(SynthDef(
	\route,
	{
		arg inBus, outBus = 0, gain = 1;
		Out.ar(outBus, In.ar(inBus, 2) * gain);
	}
).add);

(SynthDef(
	\sidechain,
	{
		arg inBus, sideBus, outBus = 0, sideAmount = 10;

		var input = In.ar(inBus, 2);
		var control = In.ar(sideBus, 2);

		var thresh = 0.1;
		var compression = 0.1;
		var attack = 0.05;
		var release = 0.5;
		c = Compander.ar(input, control * sideAmount, thresh, 1, compression, attack, release);
		Out.ar(outBus, c);
	}
).add);

(SynthDef(
	\reverb,
	{
		arg inBus, outBus = 0, maxDelayTime = 0.04;
		var input = In.ar(inBus, 1);
		64.do({
			input = AllpassC.ar(input, maxDelayTime, {Rand(0.001, maxDelayTime)}.dup, 3)
		});
		Out.ar(outBus, input);
	}
).add);

(SynthDef(
	\bandpass,
	{
		arg inBus, outBus = 0;
		var input = In.ar(inBus, 1);
		input = BPF.ar(input, rq: 2.0);
		Out.ar(outBus, input);
	}
).add);

(SynthDef(
	\decaymult,
	{
		arg inBus, outBus = 0;
		var input = In.ar(inBus, 1);
		input = input * Decay.kr(Dust.kr(1));
		Out.ar(outBus, input);
	}
).add);
)

(Pbind(
	\instrument, \hat,
	\freq, Pseq([1000, 2000, 3000, 4000, 5000], inf),
	\amp, 0.1,
	\dur, Pseq([pi/6, pi/4, pi/2, 1], inf),
).play)

// bus1 -> bus2 -> master
(

Synth(\route, [\inBus, ~masterbus, \gain, 0.5]);
Synth(\sidechain, [\inBus, ~sidechainbus, \sideBus, ~kickbus, \outBus, ~masterbus, \sideAmount, 2]);
Synth(\reverb, [\inBus, ~reverbbus, \outBus, ~sidechainbus, \maxDelayTime, 0.1]);
Synth(\bandpass,  [\inBus, ~bandpassbus, \outBus, ~reverbbus]);

Synth(\amb1, [\bus, ~bandpassbus, \freq, 11pi.midicps]); // f3
Synth(\amb1, [\bus, ~bandpassbus, \freq, 22pi.midicps]); // c4
Synth(\amb1, [\bus, ~bandpassbus, \freq, 44pi.midicps]); // a4

Synth(\amb2, [\bus, ~reverbbus, \gain, 0.05]);

Synth(\route, [\inBus, ~kickbus, \outBus, ~masterbus]);
// Synth(\kick, [\bus, ~kickbus])

(Pbind(
	\instrument, \hat,
	\freq, Pseq([1000], inf),
	\amp, 0.1,
	\dur, Pseq([1,1,1], inf),
).play)
)