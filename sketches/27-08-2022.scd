(
SynthDef("fm1", {
    arg bus = 0, freq = 440, carPartial = 1, index = 3, mul = 0.05, gate = 1;

    var mod, car, detunes, detunes2;
    detunes = ((-3..3) * 0.01).midiratio;
    detunes2 = ({ LFNoise2.kr(8) } ! 16 * Line.kr(0, 0.5, 3)).midiratio;
    mod = SinOsc.ar(
        freq,
        Rand(0.0, 1.0),
        freq * index * LFNoise1.kr(5.reciprocal).abs
    );
    car = SinOsc.ar(
        (freq * carPartial * detunes * detunes2) + mod,
        Rand(0.0, 1.0),
        mul
    );
    car = DelayC.ar(car, 0.01, { Rand(0, 0.01) } ! car.size);
    car = Splay.ar(car);
    car = car * Env.asr(3, 1, 8).ar(Done.freeSelf, gate);

    // car = LPF.ar(car, 800);

    Out.ar(bus, car);
}).add;


SynthDef(\fx, { |out=0, amp=(-5)|
  var sig;
  sig = In.ar(out, 2);
  sig = sig + NHHall.ar(sig, 3, modDepth: 1);
  sig = sig * amp.dbamp;
  sig = sig.tanh;
  sig = Limiter.ar(sig);
  ReplaceOut.ar(out, sig)
}).add;

)

(
Routine {
  var chords, frequencies;
  chords = [
    [-3, 7, 10, 12, 17, 21, 22],
    [2, 3, 10, 15, 19, 34],
    [7, 10, 14, 15, 17, 19, 34],
    [9, 10, 14, 15, 17, 22, 31],
    [0, 7, 10, 12, 17, 21, 29],
    [-7, 10, 12, 17, 21, 26],
  ];

  Synth.tail(nil, \fx);

  // Routine {
  //   loop {
  //     rrand(5.0, 8.0).wait;
  //     6.do {
  //       var chord = chords.choose;
  //       Synth(\fm1, [\bus, [0, 1].choose, \freq, chord.choose, \modPartial, rrand(1.0, 5.0)]);
  //       exprand(0.1, 0.5).wait;
  //     };
  //   }
  // }.play;

  loop {
    chords.do { |chord_temp|
      var rand = rrand(6.0, 9.0);
      var chord = chord_temp ++ (chord_temp + 24);
      chord.do { |note|
        var freq = (32 + note).midicps;
        Routine {
          var synth1, synth2;
          synth1 = Synth(\fm1, [\bus, 0, \freq, freq, \modPartial, 2.4]);
          synth2 = Synth(\fm1, [\bus, 1, \freq, freq, \modPartial, 1.401]);
          rand.wait;
          synth1.set(\gate, 0);
          synth2.set(\gate, 0);
        }.play;
      };
      rand.wait;
    }
  }
}.play;
)

// =======================================

(
SynthDef(\supersaw, { |freq=440, out=0, amp=(-10)|
  var sig, env, detunes, saw_arr;
  env = Env.perc(0.01, 5, 1, -2).kr(Done.freeSelf);
  detunes = ((-6..6) * 0.02).midiratio;
  detunes.postln;
  saw_arr = detunes.collect { |detune|
    VarSaw.ar(
      freq * detune ! 2,
      {Rand(0.0, 1.0)} ! 2,
      0.05,
    );
  };
  saw_arr = saw_arr.sum;
  sig = saw_arr * 0.05 * env;
  sig = sig * amp.dbamp;
  Out.ar(out, sig)
}).add;
)

(
SynthDef(\sawchords, { |freq=440, out=0, amp=(-10)|
  var sig, amp_env, freq_env, detunes, saw_arr;
  amp_env = Env.perc(0.01, 2, 1, -2).kr(Done.freeSelf);
  freq_env = Env.perc(0, 0.03, 1, 0).kr();
  // freq_env.plot;
  detunes = ((-6..6) * 0.02).midiratio;
  saw_arr = detunes.collect { |detune|
    VarSaw.ar(
      ((freq + (100 * freq_env)) * detune) ! 2,
      {Rand(0.0, 1.0)} ! 2,
      0.05,
    );
  };
  saw_arr = saw_arr.sum;
  sig = saw_arr * 0.05 * amp_env;
  sig = sig * amp.dbamp;
  Out.ar(out, sig)
}).add;
)

(
Synth(\sawchords, [\freq, 53.midicps]);
Synth(\sawchords, [\freq, 57.midicps]);
Synth(\sawchords, [\freq, 60.midicps]);
Synth(\sawchords, [\freq, 64.midicps]);
)
