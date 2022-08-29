(
SynthDef(\pad, { |freq=440, out=0, amp=(-20), gate=1|
  var sig, detunes, detunes2;
  detunes = ((-6..6) * 0.01).midiratio;
  detunes2 = ({ LFNoise2.kr(8) } ! 16 * Line.kr(0, 0.5, 3)).midiratio;
  sig = Saw.ar(freq * detunes * detunes2 * (SinOsc.kr(detunes) * 0.005 + 1));
  sig = DelayC.ar(sig, 0.01, { Rand(0, 0.01) } ! sig.size);
  sig = Splay.ar(sig);
  sig = BLowShelf.ar(sig, 100, 2, -12);
  sig = BPeakEQ.ar(sig, 4000, 100, 8);
  sig = BPeakEQ.ar(sig, 8000, 100, 5);
  // sig = LPF.ar(sig, XLine.kr(1200, 100, 10));

  sig = sig * Env.asr(1, 1, 8).ar(Done.freeSelf, gate);
  sig = sig * amp.dbamp;
  Out.ar(out, sig);
}).add;

SynthDef(\fx, { |out=0, amp=(-5)|
  var sig;
  sig = In.ar(out, 2);
  sig = sig * amp.dbamp;
  sig = sig.tanh;
  sig = Limiter.ar(sig);
  ReplaceOut.ar(out, sig)
}).add;
)

(
Routine {
  var frequencies, chords;
  chords = [
    [0, 10, 15, 17, 19],
    [2, 3, 10, 34],
    [-2, 12, 17, 43]
  ];

  Synth.tail(nil, \fx);

  loop {
    chords.do({ |chord|
      frequencies = (32 + (chord +.x [0, 12])).midicps;
      frequencies.scramble.do({ |frequency|
        Routine {
          var synth;
          synth = Synth(\pad, [freq: frequency]);
          8.wait;
          synth.set(\gate, 0);
        }.play;
        0.02.wait;
      });
      8.wait;
    })
  }
}.play;
)

// ============================== //
