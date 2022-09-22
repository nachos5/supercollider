(

"buffers.scd".loadRelative;

)

(

[
  "bass.scd",
  "blip.scd",
  "fm-pad.scd",
  "pluck.scd",
  "sin-pattern.scd",
  "drums.scd",
  "synths.scd",
].do { |file|
  file.loadRelative;
};

)
