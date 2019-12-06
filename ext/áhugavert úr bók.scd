s.boot

{Blip.ar(25, LFNoise0.kr([5, 10], 400, 600), 0.3)}.play // stereo - 5 sinnum á sek í vinstra og 10 sinnum á sek í vinstra

{LFNoise0.ar([50, 100], 0.5)}.play //annað dæmi


{PMOsc.ar(440, MouseY.kr(1, 550), MouseX.kr(1, 15))!2}.play // músar flipp

({PMOsc.ar(
	(Line.ar(2000, 6000, 20, (Line.ar(1, 2, 20)))),
	(Line.ar(8000, 2000, 20, (Line.ar(2, 1, 20)))),
	(Line.ar(4, 8, 20))
)}.play) //verkefni að nota line með PMOsc



(
{
	Blip.ar(
		TRand.kr( // frequency or VCO
			100, 1000, // range
			Impulse.kr(Line.kr(1, 20, 60))), // trigger
		TRand.kr( // number of harmonics or VCF
			1, 10, // range
			Impulse.kr(Line.kr(1, 20, 60))), // trigger
		Linen.kr( // mul, or amplitude, VCA
			Impulse.kr(Line.kr(1, 20, 60)), // trigger
			0, // attack
			0.5, // sustain level
			1/Line.kr(1, 20, 60)) // trigger
		)
}.play
)



(
{
r = MouseX.kr(1/3, 10);
SinOsc.ar(mul: Linen.kr(Impulse.kr(r), 0, 1, 1/r))
!2}.play
) //linen segir hvað hver impulse er lengi



(({
	x = Dust.kr(2);
	y = TRand.kr(5020, 5040, x);
	r = TRand.kr(5000, 5020, (x+0.3));
	z = Linen.kr(y, 0.3);
	(SinOsc.ar([y, y], mul: z))
	+ (SinOsc.ar([r, r], mul: z))

}).play)  //flipp tilraun


((
	SynthDef("flipp", { //hægt að hugsa synthdef sem UGen þar sem "nafn", {var með öllu svo Out.ar(0, var)}
	arg plebbi = 0;
	var loller = SinOsc.ar(plebbi);
		Out.ar([0,1], loller)})
).play)

a = Synth("flipp", ["plebbi", 90]) // breytir plebba argumentinu í 90
a.set("plebbi", 980) //breytir í 980

//

~inhale = Buffer.read(s, "sounds/inhale.wav");
{PlayBuf.ar(2, ~inhale)}.play; // number of channels and buffer.

[~inhale.bufnum, ~inhale.numChannels, ~inhale.path, ~inhale.numFrames];

(  // phasing
{
	var rate, trigger, frames;
	frames = ~inhale.numFrames; // or use ~chooston.numFrames

	rate = [1, 1.01];
	trigger = Impulse.kr(rate);
	PlayBuf.ar(1, ~inhale, 1, trigger, frames * Line.kr(0, 1, 10)) *  //frá fyrsta ramma til síðasta á 10 sek
	EnvGen.kr(Env.linen(0.1, 0.96, 0.01), trigger) * rate;
}.play; //env linen er attack, sustain, release, level, curve
)

TGrains.ar  //skoða

//



~kbus3 = Bus.control; // a control bus, gefa ekki hljóð, sjá Bus.audio

~kbus4 = Bus.control; // a control bus
  // run these one at a time, (turn down the speakers!)

({
	(Out.kr(~kbus3, SinOsc.kr(3).scope("out3") * 100);
		Out.kr(~kbus3, LFNoise0.kr(3000).scope("out3") * 100);

Out.kr(~kbus4, LFPulse.kr(1/3).scope("out4") * 200);

		Out.ar(0, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 440).scope("left"));

		Out.ar(1, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 880).scope("right"));)

}.play)  //out.kr segir hvað er á businu, in.kr framkallar
//out.ar þá 0 er vinstri, 1 hægri,

//

Task({
a = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
"count, midi, pitch, octave".postln;
	do(50, {arg counts;
		p = rrand(36, 72);
		[counts, p, a.wrapAt(p), (p/12).round(1) - 1].postln;
	1.wait;
	})
}).play //grunnurinn í arrays, task lætur bíða

//










