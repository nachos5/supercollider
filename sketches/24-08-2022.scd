(
SynthDef(\pad, { |freq=440, gate=1, out=0, amp=(-25)|
  var sig, detunes;
  // evaluate-um LFNoise - setjum á 16 channel, fade-um detune inn, verður -0.5 - 0.5 eftir 3 sek
  // midiratio convertar midi nótu í freq, þar sem 0 er 1 og þetta er exponential skali þá getum við nýtt okkur midiratio til að fá gildi nálægt 1
  detunes = ({ LFNoise2.kr(8) } ! 16 * Line.kr(0, 0.5, 3)).midiratio;
  // áttundir
  detunes = detunes * [1, 2, 1, 3, 1, 2, 1, 2, 3, 1, 2, 1, 2, 1, 2, 1];
  sig = LFTri.ar(freq * detunes);
  sig = DelayC.ar(sig, 0.01, { Rand(0, 0.01) } ! sig.size);
  sig = Splay.ar(sig);
  sig = LPF.ar(sig, XLine.kr(1000, 100, 8));
  sig = BPeakEQ.ar(sig, freq * 8, 0.1, 8);
  sig = sig * Env.asr(1, 1, 8).ar(Done.freeSelf, gate);
  sig = sig * amp.dbamp;

  Out.ar(out, sig);
}).add;

SynthDef(\fm, { |freq=440, out=0, amp=(-15), pan=0|
  var sig, freq2;
  freq2 = freq * (LFNoise2.kr(0.3) * 0.1).midiratio;
  sig = SinOsc.ar(freq2 + (SinOsc.ar(freq2 * (800 / freq2).round) * 1000));
  sig = sig + SinOsc.ar(freq2 + (SinOsc.ar(freq2 * (2000 / freq2).round) * 1000));
  sig = LPF.ar(sig, 2000) * amp.dbamp;
  sig = sig * Env.perc(0.5, 3).ar(Done.freeSelf);
  sig = sig * amp.dbamp;
  // sig = PitchShift.ar(sig, 0.2, 0.5, 0, 0.1);
  sig = Pan2.ar(sig, pan);
  Out.ar(out, sig);
}).add;

SynthDef(\fx, { |out=0|
  var sig;
  sig = In.ar(out, 2);
  sig = PitchShift.ar(sig, 0.2, 2, 0, 0.1);
  sig = sig + NHHall.ar(sig, 3, modDepth: 1);
  sig = BHiShelf.ar(sig, 3000, 1, -10 + (5 * LFNoise2.kr(16 ! 2)));
  sig = BPeakEQ.ar(sig, 240, 0.1, -8 * LFNoise2.kr(16 ! 2));
  sig = BPeakEQ.ar(sig, 460, 0.1, -8 * LFNoise2.kr(16 ! 2));
  sig = BPeakEQ.ar(sig, 460, 0.1, -8 * LFNoise2.kr(16 ! 2));
  sig = BLowShelf.ar(sig, 100, 1, 10);
  sig = sig * -10.dbamp;
  sig = sig.tanh;
  sig = Limiter.ar(sig);
  ReplaceOut.ar(out, sig);
}).add;

)


(
Routine {
  var frequencies, chords;
  chords =  [
    [0, 2, 3, 10, 15, 17, 19],
    [0, 2, 3, 10, 15, 17, 19, 24, 34],
    [-2, 3, 7, 10, 12, 17, 24, 26, 27, 43]
  ];

  Synth.tail(nil, \fx);

  Routine {
    loop {
      rrand(5.0, 8.0).wait;
      6.do {
        if (frequencies.notNil) {
          Synth(\fm, [freq: frequencies.choose, amp: -10, pan: rrand(-1.0, 1.0)]);
        };
        exprand(0.1, 0.5).wait;
      }
    }
  }.play;

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

a = [1,2,3];
b = a + 12;
a ++ b;
