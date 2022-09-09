(

SynthDef(\pluck, { |freq=440, out=0, amp=(-10), velocity=10, attack_time=0.01|
  var sig, amp_env, freq_env, detunes, mod;
  amp_env = Env.perc(attack_time, 0.5, 1, -1).kr(Done.freeSelf);
  freq_env = Env.perc(0, 0.01, 1, 0).kr();
  detunes = ((-3..3) * 0.01).midiratio;
  sig = VarSaw.ar((freq + (50 * freq_env)) * detunes, Rand(0.0, 1.0), 0.05);
  sig = Splay.ar(sig);
  sig = sig * amp_env;
  sig = sig * amp.dbamp;
  sig = sig * (velocity / 10);
  Out.ar(out, sig)
}).add;

SynthDef(\bass, { |freq=110, out=0, amp=(-5), gate=1|
  var sig, amp_env, detunes, detunes2, voc_mod;
  amp_env = Env.asr(0.01, 0.05, 1).ar(Done.freeSelf, gate);
  detunes = ((-3..3) * 0.01).midiratio;
  detunes2 = ({ LFNoise2.kr(8) } ! 16 * Line.kr(0, 0.5, 3)).midiratio;
  sig = VarSaw.ar(freq, Rand(0.0, 1.0), 0.05);
  sig = Splay.ar(sig);
  sig = (sig * 2).fold2;

  voc_mod = SinOsc.ar(freq * detunes * detunes2, Rand(0.0, 1.0));
  voc_mod = Splay.ar(voc_mod);
  sig = Vocoder.ar(sig, voc_mod, num: 128, low: 40, high: 7500, q: 0.03);
  sig = (sig * 0.1).tanh;


  sig = sig * amp_env;
  sig = sig * amp.dbamp;

  Out.ar(out, sig)
}).add;

SynthDef(\blip, { |freq=440, out=0, amp=(-10)|
  var sig, env;
  env = Env.perc(0.01, 0.2).kr(Done.freeSelf);
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = sig * amp.dbamp;
  sig = sig + FreeVerb.ar(sig, 0.5, 0.8, 0.2) ! 2;
  Out.ar(out, sig)
}).add;


SynthDef(\fm_pad, { |out=0, freq=440, carPartial=1, index=3, mul=0.05, gate=1|

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
    car = car * Env.asr(3, 1, 4).ar(Done.freeSelf, gate);

    // car = LPF.ar(car, 800);

    Out.ar(out, car);
}).add;

SynthDef(\fx_pluck, { |in=0, out=0, amp=(-10)|
  var sig;
  sig = In.ar(in, 2);
  sig = sig * amp.dbamp;
  Out.ar(out, sig)
}).add;

SynthDef(\fx_master, { |out=0|
  var sig;
  sig = In.ar(out, 2);
  sig = Limiter.ar(sig);
  ReplaceOut.ar(out, sig);
}).add;

SynthDef(\fx_send, { |in=0, out=0, amp=(-10)|
  var sig;
  sig = In.ar(in, 2);
  sig = sig * amp.dbamp;
  Out.ar(out, sig);
}).add;

SynthDef(\fx_reverb, { |in=0, out=0, amp=(-10)|
  var sig;
  sig = In.ar(in, 2);
  sig = NHHall.ar(sig, 1, modDepth: 1);
  sig = sig * amp.dbamp;
  Out.ar(out, sig);
}).add;

~ping_pong_buffer = Buffer.alloc(s, 44100 * 2, 2);

SynthDef(\fx_ping_pong_delay, { |in=0, out=0, amp=(-10),
phase=0.25, phase_slide=0, phase_slide_shape=1, phase_slide_curve=0, max_phase=1,
feedback=0.5, feedback_slide=0, feedback_slide_shape=1, feedback_slide_curve=0,
pan_start=1|
  var sig, dry, panned;

  dry = In.ar(in, 1);
  dry = AnalogPhaser.ar(
    dry,
    SinOsc.ar(0.22),
    skew: SinOsc.kr(0.059),
    feedback: SinOsc.kr(0.005, 1pi).range(0.0,0.85),
    modulation: SinOsc.kr(0.0192, 2pi).unipolar,
    stages: 50
  );

  phase = VarLag.kr(phase, phase_slide, phase_slide_curve, phase_slide_shape);
  feedback = VarLag.kr(feedback, feedback_slide, feedback_slide_curve, feedback_slide_shape);
  feedback = Clip.kr(feedback);
  pan_start = pan_start.neg;
  pan_start = Clip.kr(pan_start, -1, 1);
  panned = Balance2.ar(dry, dry, pan_start);

  sig = PingPong.ar(~ping_pong_buffer.bufnum, panned, phase, feedback, 1);
  sig = sig * amp.dbamp;
  Out.ar(out, sig)
}).add;

)
