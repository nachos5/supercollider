s.boot


//--loading a soundfile
//drag and drop a file onto this document to see the path (not mp3)
//then copy and paste that into the line below
b.free; b= Buffer.readChannel(s, "SKRÁ", channels:[0]);  //here edit path to your soundfile

//--playback
//use mouse x position to set starting position
a= {TGrains.ar(2, Impulse.ar(4), b.bufnum, 1, MouseX.kr(0, b.duration), 0.3)}.play;
a.release;

//mouse y now control trigger rate
a= {TGrains.ar(2, Impulse.ar(MouseY.kr(1, 100, 1)), b.bufnum, 1, MouseX.kr(0, b.duration), 0.3)}.play;
a.release;

//adding a sine oscillator that slowly varies the starting position (offset)
a= {TGrains.ar(2, Impulse.ar(MouseY.kr(1, 100, 1)), b.bufnum, 1, MouseX.kr(0, b.duration)+SinOsc.kr(1).range(-0.1, 0.1), 0.3)}.play;
a.release

//change playback rate with an sine oscillator
a= {TGrains.ar(2, Impulse.ar(MouseY.kr(1, 100, 1)), b.bufnum, SinOsc.kr(1).range(0.5, 2), MouseX.kr(0, b.duration), 0.3)}.play;
a.release;

//more oscillator control (no mouse interaction here)
a= {TGrains.ar(2, Impulse.kr(SinOsc.kr(1).range(1, 10)), b.bufnum, SinOsc.kr(1.1).exprange(0.3, 3), SinOsc.kr(0.1).range(0, b.duration), 0.3)}.play;
a.release;