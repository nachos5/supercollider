(

(
SynthDef(\pad, { |freq=440, gate=1, out=0|
  var sig, detunes;
  detunes = ((-3..3) * 0.05).midiratio;
  detunes.postln;
  sig = Saw.ar(freq * detunes);
  sig = RLPF.ar(sig, LFNoise2.kr(0.3).linexp(-1, 1, 100, 8000), 0.3);
  sig = Latch.ar(sig, Impulse.ar(4000));
  sig = Splay.ar(sig);
  sig = sig * Env.asr(3, 1, 3).ar(Done.freeSelf, gate);
  sig = sig * -16.dbamp;
  Out.ar(out, sig)
}).add;
);

(
SynthDef(\pad2, {
  var sig, detunes;
  detunes = ((-3..3) * 0.05).midiratio;
  sig  = Saw.ar(\freq.kr(440) * detunes);
  sig = Splay.ar(sig);
  sig = MoogFF.ar(sig, 8000, 0);
  sig = sig * Env.asr(3, 1, 3).ar(Done.freeSelf, \gate.kr(1));
  sig = Balance2.ar(sig[0], sig[1], \pan.kr(0));
  sig = sig * -16.dbamp;
  Out.ar(\out.kr(0), sig)
}).add
);

(
SynthDef(\kick, {
  var sig, mod;
  mod = 1 + Env.perc(0.01, 0.01).ar;
  sig = SinOsc.ar(60 * mod);
  sig = sig ! 2;
  sig = sig * Env.perc(0.001, 1.0).ar(Done.freeSelf);
  sig = sig * -5.dbamp;
  Out.ar(\out.kr(0), sig)
}).add
);

(
SynthDef(\padFx, {
  var sig;
  sig = In.ar(\out.kr(0), 2);
  sig = sig * (1 - Env.perc(0.01, 0.5).kr(Done.none, \gate.tr(0)));
  ReplaceOut.ar(\out.kr(0), sig);

}).add
);

(
SynthDef(\send, {
  var sig;
  sig = In.ar(\in.kr(0), 2);
  sig = sig * -10.dbamp;
  Out.ar(\out.kr(0), sig)
}).add
);

)

(
Routine  {
  var bpm, beat;
  var s;
  var padBus, padGroup, padFx;

  s = Server.default;
  padBus = Bus.audio(s, 2);
  padGroup = Group();

  bpm = 108;
  beat = 60 / bpm;

  padFx = Synth.tail(padGroup, \padFx, [out: padBus, gate: 0]);
  Synth.after(padGroup, \send, [in: padBus, out: 0]);
  s.sync;

  Routine {
    loop {
      s.makeBundle(s.latency, {
        Synth(\kick);
        padFx.set(\gate, 1);
      });
      beat.wait;
    }
  }.play;

  Routine {
    loop {
      Routine {
        var midinote, synth;
        midinote = (62 + [0, 10, 12, 14, 15, 17, 19]).choose;
        s.makeBundle(s.latency, {
          synth = Synth(\pad2, [freq: midinote.midicps, out: padBus, pan: rrand(-1.0, 1.0)], padGroup);
        });
        rrand(8, 16).wait;
        s.makeBundle(s.latency {
          synth.set(\gate, 0);
        });
      }.play;
      rrand(1, 3).wait;
    }
  }.play;

}.play;
)
