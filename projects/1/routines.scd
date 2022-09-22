(

Routine {
  var s, bpm, beat, tatum, attack_time;
  var pluck_bus, pluck_fx_bus, pluck_group, pluck_fx_synth, pluck_amp;
  var bass_notes;
  var fm_pad_bus, fm_pad_group, fm_pad_notes, fm_pad_amp;
  var blip_bus, blip_notes;
  var sin_pattern_notes;
  var mute_bass, mute_fm_pad, mute_blip, mute_sin_pattern, mute_pluck, mute_kick, mute_snare;

  s = Server.default;
  pluck_bus = Bus.audio(s, 2);
  pluck_fx_bus = Bus.audio(s, 2);
  pluck_group = Group();

  fm_pad_bus = Bus.audio(s, 2);
  fm_pad_group = Group();

  blip_bus = Bus.audio(s, 2);

  bpm = 60;
  beat = 60 / bpm;
  tatum = beat / 4;
  // beat.postln;

  Synth.tail(pluck_group, \fx_pluck, [\in, pluck_bus, \out, pluck_fx_bus, \amp, -15]);
  Synth.tail(pluck_group, \fx_pluck, [\in, blip_bus, \out, pluck_fx_bus, \amp, -10]);
  // send pluck fx bus to master channel
  pluck_amp = -3;
  Synth.after(pluck_group, \fx_send, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp]);
  Synth.after(pluck_group, \fx_reverb, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp]);
  Synth.after(pluck_group, \fx_ping_pong_delay, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp + (pluck_amp * 2), \feedback, 0.5, \phase, 0.5]);
  //
  fm_pad_amp = 1;
  Synth.after(fm_pad_group, \fx_send, [\in, fm_pad_bus, \out, 0, \amp, fm_pad_amp]);
  Synth.after(fm_pad_group, \fx_reverb, [\in, fm_pad_bus, \out, 0, \amp, fm_pad_amp * 4]);

  Synth.tail(nil, \fx_master);

  mute_bass = 0;
  mute_fm_pad = 0;
  mute_blip = 0;
  mute_sin_pattern = 0;
  mute_pluck = 0;
  mute_kick = 0;
  mute_snare = 0;

  attack_time = 0.1;
  bass_notes = [];
  fm_pad_notes = [];
  blip_notes = [];
  sin_pattern_notes = [];

  s.sync;

  // bass
  Routine {
    loop {
      ~play_note_arr.(
        ~bass_note_arr,
        [\freq, \velocity],
        \bass,
        tatum,
        notes_arr: bass_notes,
        mute: mute_bass,
      );
    };
  }.play;


  // fm pad
  Routine {
    loop {
      ~play_note_arr.(
        ~fm_pad_note_arr,
        [\freq, \velocity],
        \fm_pad,
        tatum,
        additional_arguments: [\out, fm_pad_bus],
        notes_arr: fm_pad_notes,
        mute: mute_fm_pad,
      );
    };
  }.play;

  // blip
  Routine {
    loop {
      ~play_note_arr.(
        ~blip_note_arr,
        [\freq, \velocity],
        \blip,
        tatum,
        additional_arguments: [\out, blip_bus],
        mute: mute_blip,
      );
    };
  }.play;

  // sin pattern
  Routine {
    loop {
      ~play_note_arr.(
        ~sin_pattern_note_arr,
        [\freq],
        \sin_pattern,
        tatum,
        notes_arr: sin_pattern_notes,
        mute: mute_sin_pattern,
      );
    };
  }.play;

  // saw pluck
  Routine {
    loop {
      ~play_note_arr.(
        ~pluck_note_arr,
        [\freq, \velocity],
        \pluck,
        tatum,
        group: pluck_group,
        additional_arguments: [\out, pluck_bus, \amp, -20, \attack_time, attack_time],
        // before_wait: { attack_time = attack_time + 0.005; },
        mute: mute_pluck,
      );
    };
  }.play;

  Routine {
    loop {
      ~play_note_arr.(
        ~kick_note_arr,
        [\velocity, \rate],
        \kick,
        tatum,
        mute: mute_kick,
      );
    };
  }.play;

  Routine {
    loop {
      ~play_note_arr.(
        ~snare_note_arr,
        [\velocity, \rate],
        \snare,
        tatum,
        mute: mute_snare,
      );
    };
  }.play;

}.play;

)
