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
  sig = Vocoder.ar(sig, voc_mod, num: 128, low: 40, high: 750, q: 0.03);
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
    car = car * Env.asr(3, 1, 4).kr(Done.freeSelf, gate);

    // car = LPF.ar(car, 800);

    Out.ar(out, car);
}).add;


SynthDef(\sin_pattern, { |freq=440, out=0, amp=(-15), gate=1|
var sig, sig2, pattern_arr, amp_env;
pattern_arr = 1 / (2..6);
amp_env = Env.asr(0.01, 1, 1).ar(Done.freeSelf, gate);

sig = SinOscFB.ar(pattern_arr, 1) < pattern_arr;
sig = sig * freq;
sig = SinOscFB.ar(sig);

sig2 = SinOscFB.ar(pattern_arr, 1) < 0.1 + 1;
sig2 = SinOscFB.ar(sig2) % pattern_arr;
sig2 = SinOscFB.ar(
  freq,
  sig2,
  SinOscFB.ar(0.1 - pattern_arr, 1).min(0);
);

sig = sig / 4 + sig2 / 4;

sig = Splay.ar(sig);
sig = sig * amp_env;
sig = sig * amp.dbamp;
Out.ar(out, sig);
}).add;

SynthDef(\kick, { |velocity=10, rate=1, out=0, amp=(-10)|
  var kick, kick_1, kick_2;
  kick_1 = PlayBuf.ar(~kick.numChannels, ~kick, rate: BufRateScale.kr(~kick) * rate, doneAction: Done.freeSelf);
  kick_2 = PlayBuf.ar(~kick_2.numChannels, ~kick_2, rate: BufRateScale.kr(~kick_2) * rate, doneAction: Done.freeSelf);
  if (~kick.numChannels == 1, {
    kick_1 = kick_1!2;
  });
  if (~kick_2.numChannels == 1, {
    kick_2 = kick_2!2;
  });
  kick_1 = kick_1 * (velocity / 10);
  kick_2 = kick_2 * (velocity / 10);

	kick_1 = BPeakEQ.ar(kick_1, freq: 136.63, rq: 0.67, db: -3.18);
	kick_1 = BPeakEQ.ar(kick_1, freq: 476.94, rq: 1, db: -3.86);
	kick_1 = BPeakEQ.ar(kick_1, freq: 5384.4, rq: 1.87, db: 3.86);
	kick_1 = BPeakEQ.ar(kick_1, freq: 7591.6, rq: 0.4, db: -3.06);
	kick_2 = BHiPass.ar(kick_2, freq: 17.728, rq: 1);
	kick_2 = BPeakEQ.ar(kick_2, freq: 52.116, rq: 1, db: 1.5);
	kick_2 = BLowPass.ar(kick_2, freq: 76.339, rq: 0.86);
	// kick_2 = AnalogVintageDistortion.ar(kick_2, bias: 0.7, drivegain: 0.2, lowgain: 0.05, highgain: 0.06);

  kick = Mix([kick_1, kick_2]);
  kick = kick * 0.5;

	kick = DCompressor.ar(kick, sidechain: 0, ratio: 4, threshold: -24.1, attack: 30, release: 41.1, automakeup: 0);
	kick = BHiPass.ar(kick, freq: 31.429, rq: 0.7);
	kick = BPeakEQ.ar(kick, freq: 49.256, rq: 1.31, db: 2.45);
	kick = BPeakEQ.ar(kick, freq: 351.44, rq: 2.75, db: -3.92);
	kick = BPeakEQ.ar(kick, freq: 7519.5, rq: 2.22, db: 2);

  kick = kick * amp.dbamp;

  Out.ar(out, kick);
}).add;

SynthDef(\snare, { |velocity=10, rate=1, out=0, amp=(-10)|
  var sig;
  sig = PlayBuf.ar(~snare.numChannels, ~snare, rate: BufRateScale.kr(~snare) * rate * 0.88, doneAction: Done.freeSelf);
~kick_2 = Buffer.read(s, ~assets_folder ++ "/trommur/VEH3 Kicks 015.wav");
  if (~snare.numChannels == 1, {
    sig = sig!2;
  });
  sig = sig * (velocity / 10);

	sig = BHiPass.ar(sig, freq: 88.088, rq: 0.98);
	sig = BPeakEQ.ar(sig, freq: 132.78, rq: 0.47, db: 11.2);
	sig = BPeakEQ.ar(sig, freq: 1053, rq: 0.53, db: -4.08);
	sig = BPeakEQ.ar(sig, freq: 6272.6, rq: 0.27, db: -2.4);
	sig = BLowPass.ar(sig, freq: 8200, rq: 0.93);
	sig = DCompressor.ar(sig, sidechain: 0, ratio: 4, threshold: -35, attack: 31.1, release: 6.35, automakeup: 0);

  sig = sig * 0.3;

  sig = sig * amp.dbamp;

  Out.ar(out, sig);
}).add;

SynthDef(\fx_pluck, { |in=0, out=0, amp=(-10)|
  var sig;
  sig = In.ar(in, 2);
  sig = sig * amp.dbamp;
  Out.ar(out, sig);
}).add;

SynthDef(\fx_master, { |out=0|
  var sig;
  sig = In.ar(out, 2);
  sig = Limiter.ar(sig);
  sig = SafetyLimiter.ar(sig);
  ReplaceOut.ar(0, sig);
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

SynthDef(\fx_ping_pong_delay, { |in=0, out=0, amp=(-10),
phase=0.25, phase_slide=0, phase_slide_shape=1, phase_slide_curve=0, max_phase=1,
feedback=0.5, feedback_slide=0, feedback_slide_shape=1, feedback_slide_curve=0,
pan_start=1|
  var sig, dry, panned;

  dry = In.ar(in, 1);
  dry = AnalogPhaser.ar(
    dry,
    SinOsc.kr(0.22),
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
