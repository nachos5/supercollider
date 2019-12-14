s.boot;
a=LFCub;play{RecordBuf.ar(InFeedback.ar+a.ar(99),b=Buffer.alloc(s,8e4));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1.5,0,3)}
b = Buffer.alloc(s, 44100 * 4, 1);

// sínusbylgja í buffer
(SynthDef(
	\test,
	{
		arg freq = 440, sek = 4.0;
		var playbuf;
		x = SinOsc.ar(freq=freq)!2;
		RecordBuf.ar(x, b);
		playbuf = PlayBuf.ar(2, b);
		FreeSelfWhenDone.kr(playbuf);
		Out.ar(0, playbuf)!2;
	}
).play;)

Synth(\test);
Synth(\test, [\freq, 220]);


(SynthDef(
	\test2,
	{
		arg freq = 220, sek = 4.0;
		var playbuf, grains;
		x = InFeedback.ar + LFCub.ar(freq=freq);
		RecordBuf.ar(x, b);
		playbuf = PlayBuf.ar(1, b);
		//FreeSelfWhenDone.kr(playbuf);
		grains = TGrains.ar(2, LFCub ar:c=[3,2],b,LFCub.ar(1/c)>0/2+1.5,0,3);
		Out.ar(0, grains);
	}
).play;)

Synth(\test2);
Synth(\test2, [\freq, 110]);
Synth(\test2, [\freq, 220]);
