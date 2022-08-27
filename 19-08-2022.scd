(
SynthDef(\pad, {
  var snd, freq, detunes;
  freq = \freq.kr(400);
  detunes = ((-3..3) * 0.01).midiratio;
  snd = SinOsc.ar(freq * detunes + (SinOsc.ar(freq * (3000 / freq).round * detunes) * 1000));
  snd = Splay.ar(snd);
  snd = snd * Env.asr(1, 1, 1).ar(Done.freeSelf, \gate.kr(1));
  snd = snd * -10.dbamp;
  Out.ar(\out.kr(0), snd);
}).add;
)

(
Routine {
  loop {
    var synths;
    synths = [62, 64, 65].collect({ |midinote|
      Synth(\pad, [freq: midinote.midicps]);
    });
    5.wait;
    synths.do({ |synth|
      synth.set(\gate, 0);
    })
  }
}.play
)

(
SynthDef(\pad, {
  var snd, freq, detunes;
  freq = \freq.kr(400);
  detunes = ((-3..3) * 0.01).midiratio;
  snd = SinOsc.ar(
    freq
    * detunes
    + (SinOsc.ar(freq * (600 / freq).round * detunes, Rand(0, 2pi)) * 100), Rand(0, 2pi)
  );
  snd = Splay.ar(snd);
  snd = snd * SinOsc.ar(
    freq
    * detunes
    + (SinOsc.ar(freq * (1150 / freq).round * detunes, Rand(0, 2pi)) * 100), Rand(0, 2pi)
  );
  snd = Splay.ar(snd);
  snd = snd * Env.asr(1, 1, 1).ar(Done.freeSelf, \gate.kr(1));
  snd = snd * -20.dbamp;
  Out.ar(\out.kr(0), snd);
}).add;
)

(
Routine {
  loop {
    var synths;
    synths = [24, 62, 69].collect({ |midinote|
      Synth(\pad, [freq: midinote.midicps]);
    });
    7.wait;
    synths.do({ |synth|
      synth.set(\gate, 0);
    })
  }
}.play
)
