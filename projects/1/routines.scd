(

Routine {
  var s, bpm, beat, tatum, attack_time;
  var pluck_bus, pluck_fx_bus, pluck_group, pluck_fx_synth, pluck_amp;
  var bass_notes;
  var fm_pad_bus, fm_pad_group, fm_pad_notes, fm_pad_amp;
  var blip_bus, blip_notes;

  s = Server.default;
  pluck_bus = Bus.audio(s, 2);
  pluck_fx_bus = Bus.audio(s, 2);
  pluck_group = Group();

  fm_pad_bus = Bus.audio(s, 2);
  fm_pad_group = Group();

  blip_bus = Bus.audio(s, 2);

  // bpm = 170;
  bpm = 60;
  beat = 60 / bpm;
  tatum = beat / 4;

  // Synth.tail(pluck_group, \fx_pluck, [\in, pluck_bus, \out, pluck_fx_bus, \amp, -15]);
  // Synth.tail(pluck_group, \fx_pluck, [\in, blip_bus, \out, pluck_fx_bus, \amp, -10]);
  // send pluck fx bus to master channel
  pluck_amp = -3;
  // Synth.after(pluck_group, \fx_send, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp]);
  // Synth.after(pluck_group, \fx_reverb, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp]);
  // Synth.after(pluck_group, \fx_ping_pong_delay, [\in, pluck_fx_bus, \out, 0, \amp, pluck_amp + (pluck_amp * 2), \feedback, 0.5, \phase, 0.5]);

  fm_pad_amp = -3;
  Synth.after(fm_pad_group, \fx_send, [\in, fm_pad_bus, \out, 0, \amp, fm_pad_amp]);
  Synth.after(fm_pad_group, \fx_reverb, [\in, fm_pad_bus, \out, 0, \amp, fm_pad_amp * 4]);

  Synth.tail(nil, \fx_master);

  attack_time = 0.1;
  bass_notes = [];
  fm_pad_notes = [];
  blip_notes = [];

  s.sync;

  // bass
  // Routine {
  //   loop {
  //     ~bass_note_arr.do { |note_dicts|
  //       note_dicts.do { |note_dict|
  //         var synth, arguments;
  //         arguments = note_dict.use {
  //           [\freq, \velocity].envirPairs;
  //         };
  //         synth = Synth(\bass, arguments);
  //         // todo: fallback
  //         bass_notes = bass_notes.add([synth, note_dict[\tatum_duration]]);
  //       };
  //       tatum.wait;
  //       bass_notes = ~check_tatum_duration_for_notes_array.(bass_notes);
  //     }
  //   };
  // }.play;


  // fm pad
  Routine {
    loop {
      ~fm_pad_note_arr.do { |note_dicts|
        note_dicts.do { |note_dict|
          var synth, arguments;
          arguments = note_dict.use {
            [\freq, \velocity].envirPairs;
          };
          arguments = arguments ++ [\out, fm_pad_bus];
          s.makeBundle(s.latency, {
            synth = Synth(\fm_pad, arguments);
          });
          fm_pad_notes = fm_pad_notes.add([synth, note_dict[\tatum_duration]]);
        };
        tatum.wait;
        fm_pad_notes = ~check_tatum_duration_for_notes_array.(fm_pad_notes);
      }
    };
  }.play;

  // blip
  Routine {
    loop {
      ~blip_note_arr.do { |note_dicts|
        note_dicts.do { |note_dict|
          var synth, arguments;
          arguments = note_dict.use {
            [\freq, \velocity].envirPairs;
          };
          arguments = arguments ++ [\out, blip_bus];
          s.makeBundle(s.latency, {
            synth = Synth(\blip, arguments, pluck_group);
          });
        };
        tatum.wait;
      }
    };
  }.play;

  loop {
    ~pluck_note_arr.do { |note_dicts|
      note_dicts.do { |note_dict|
        var synth, arguments;
        arguments = note_dict.use {
          [\freq, \velocity].envirPairs;
        };
        arguments = arguments ++ [\out, pluck_bus, \amp, -20, \attack_time, attack_time];
        s.makeBundle(s.latency, {
          synth = Synth(\pluck, arguments, pluck_group);
        });
      };
      // attack_time = attack_time + 0.005;
      tatum.wait;
    }
  };


}.play;

)
