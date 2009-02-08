========================================================
phunktor: javascript live coding environment for the mac
========================================================


like this::

  function play_note(time, address, channel, key, velocity, duration) {
    clock.callback(time, function() {
        osc.note_on(address, channel, key, velocity);
        clock.callback(time + duration, function() {
            osc.note_off(address, channel, key);
          });
      });
  };

  var virus_ti = "/OSC_MIDI_4/MIDI";
  var channel = 0;
  var second = 44100.0 * 10000.0;
  var beat = second;

  function pulse(time) {
    play_note(time, virus_ti, 0, 60, 96, beat / 3.0);
    clock.callback(time, function() {
        pulse(time + beat);
      });
  };
  pulse(clock.now());


