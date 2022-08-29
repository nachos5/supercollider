// experimenting with note map

(
SynthDef(\bass, { |freq=110, out=0, amp=(-10)|
  var sig, amp_env, freq_env, detunes;
  amp_env = Env.perc(0.01, 0.5, 1, -1).kr(Done.freeSelf);
  sig = SinOsc.ar(freq);
  sig = sig * amp_env;
  sig = sig * amp.dbamp;
  sig = sig ! 2;
  sig = sig.tanh;
  Out.ar(out, sig)
}).add;

SynthDef(\pluck, { |freq=440, out=0, amp=(-10), velocity=10|
  var sig, amp_env, freq_env, detunes, mod;
  amp_env = Env.perc(0.00, 0.5, 1, -1).kr(Done.freeSelf);
  freq_env = Env.perc(0, 0.01, 1, 0).kr();
  detunes = ((-3..3) * 0.01).midiratio;
  sig = VarSaw.ar((freq + (50 * freq_env)) * detunes, Rand(0.0, 1.0), 0.05);
  sig = Splay.ar(sig);
  sig = sig * amp_env;
  sig = sig * amp.dbamp;
  sig = sig * (velocity / 10);
  Out.ar(out, sig)
}).add;

SynthDef(\fx, { |out=0, amp=(-10)|
  var sig;
  sig = In.ar(out, 2);
  sig = sig + NHHall.ar(sig, 1, modDepth: 1);
  sig = sig * amp.dbamp;
  sig = sig.tanh;
  sig = Limiter.ar(sig);
  ReplaceOut.ar(out, sig);
}).add;

)

(

~note_map = IdentityDictionary[
  $a -> 69,
  $h -> 71,
  $c -> 72,
];

~string = "
a h|v:8
h|v:5
h c|v:18
";

~parse_note_string = { |string|
  var lines;
  lines = string.split($\n);
  // first and last line are empty
  lines = lines[1..lines.size - 2];
  // lines contain list of notes seperated by a whitespace
  lines = lines.collect { |line|
    var notes;
    notes = line.stripWhiteSpace.split($ );
    // collect a dictionary for each note which includes frequency and modifiers
    notes = notes.collect { |note|
      var arguments, note_and_modifiers, note_final, modifiers;
      arguments = [];
      note_and_modifiers = note.split($|);
      note_final = note_and_modifiers[0];
      arguments = arguments.add(\freq);
      arguments = arguments.add(~note_map[note_final[0]].midicps);
      modifiers = note_and_modifiers[1..];
      // modifiers are on format id:value
      modifiers.do { |modifier|
        var modifierSplit, modifierId, modifierValue;
        modifierSplit = modifier.split($:);
        modifierId = modifierSplit[0];
        modifierValue = modifierSplit[1];
        switch (modifierId)
          { "v" } {
            arguments = arguments.add(\velocity);
            arguments = arguments.add(modifierValue.asInteger);
          };
      };
      arguments;
    };
    notes;
  };

  lines;
};

~note_arr = ~parse_note_string.value(~string);

)




(

Routine {
  var s, bpm, beat, tatum;
  s = Server.default;
  bpm = 90;
  beat = 60 / bpm;
  tatum = beat / 4;

  // Synth.tail(nil, \fx);
  s.sync;

  loop {
    ~note_arr.do { |line|
      line.do { |note|
        var synth;
        synth = Synth(\pluck, note);
      };
      tatum.wait;
    }
  }
}.play;
)

Synth(\bass);
