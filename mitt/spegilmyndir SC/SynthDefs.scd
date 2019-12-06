(
SynthDef(\silence,{arg freq = 439.5; //frequency range, miðast við a4
	var offset = 0; //MUNA OFFSET
	Out.ar(0,(
		a = (Pitch.kr(execFreq: 10, in: SoundIn.ar, ampThreshold: 0.1, peakThreshold: 0.5, initFreq: 0, minFreq: 150, maxFreq: 4000, maxBinsPerOctave: 25, median: 8))[0, 1].poll; //les pitch frá mic, .poll
		b = (a > (freq+offset)) * (a < ((freq+10)+offset)); //freq stærri en 430 og minni en 450
		SinOsc.ar(0, 0, 0)*FreeSelf.kr([-1,-1, b])) //[] til að setja í 3.channel og fá ekkert sound, SinOsc er bara fyrir þögn; gæti verið hvaða ugen sem er
)}).add;


Synth(\silence);


//

SynthDef(\bassi1,{arg lol = 6, lol2 = 11.1;Out.ar(0,

	z = (a=LFSaw;b=(1..11).rotate(90)*(MouseY.kr(0.2,100));LeakDC.ar(Splay.ar(Sweep.ar(0,b+502.34).fold(a.ar(11.11/b)/2-0.5,a.ar(lol2/b)/2+lol))))*0.5;

	    y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	y * EnvGen.kr(Env.linen(3,5,20,1,\sin), doneAction:2)

)}).add;

Synth(\bassi1);
Synth(\bassi1, [\lol, 12.1, \lol2, 1]);


//

SynthDef(\acid,{arg lol = 6, lol2 = 11.1;Out.ar(0,
	z = (a=SinOscFB;Splay.ar(a.ar(a.ar(b=MouseX.kr(1,100)/(2..6),1)<b*MouseY.kr(1000,1)+99)/MouseY.kr(1,10)+a.ar(MouseX.kr(1,100)*b,a.ar(a.ar(b,1)<0.1+1,1)%b,a.ar(MouseY.kr(1,100)-b,1).min(0)))/2)*0.5;
	  y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	y * EnvGen.kr(Env.linen(0.2,5,15,1,\sin), doneAction:2)
)}).add;

Synth(\acid);

//

SynthDef(\reverb,{arg lol = 299, volume = 1.8;Out.ar(0,

	z = (a=SinOsc.ar(LFNoise0.ar(10).range(100,2e3),0,0.05)*Decay.kr(Dust.kr(1));GVerb.ar(a*LFNoise1.ar(40),lol,400,0.2,0.5,50,0,0.2,0.9)*volume);
	 y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	y * EnvGen.kr(Env.linen(0.2,25,25,1,\sin), doneAction:2)

)}).add;

Synth(\reverb);
Synth(\reverb, [\lol, 2, \volume, 1]);

//


SynthDef(\klang,{arg lol = 1;Out.ar(0,

	z = (Mix.fill(22, {arg index;

		x=[100.98, 87.495];Klank.ar(`[[(x+index*index), x*(9*index.atan)*(LFNoise1.kr(lol).range(1,9)), x*(lol).atan], nil, nil], Dust.ar(MouseX.kr(0.1, 0.9, 1), 0.1))
}));
	 y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	y * EnvGen.kr(Env.linen(0.2,20,1,1,\sin), doneAction:2)

)}).add;

Synth(\klang);
Synth(\klang, [\lol, 10]);


//

SynthDef(\motor,{arg lol = 0.5;Out.ar(0,

	z = FreeVerb.ar(((a=SinOsc;d=BufRd.ar(2,b=LocalBuf(c=2e5,2).clear,a.ar([MouseX.kr(1.0,5.0),MouseY.kr(1.1,4)]*10)*c,0);BufWr.ar(a.ar(3/[2,3])/3,b,a.ar([MouseX.kr(1,101),TRand.kr(50,2000,LFNoise0.kr(3))]).abs*c);d)), lol, 0.6)*0.6;
	y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	y * EnvGen.kr(Env.linen(1,1.2,4,1,\sin), doneAction:2)
)}).add;

Synth(\motor, [\lol, rrand(0.1,1.5)]);


//


SynthDef(\wolfs,{Out.ar(0,
	z= (a=SinOsc;tanh((c=InFeedback.ar(0,2))+HPF.ar(a.ar(b=MouseX.kr(0.09, 100, 1)/[5,4],a.ar(a.ar(b*1.3,a.ar(b*2))+a.ar(b*1.5,c,MouseY.kr(1,15,1),4).ceil*99)),9)));
	y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y*0.2) * EnvGen.kr(Env.linen(1,8,6,1,\sin), doneAction:2)
	)}).add;

Synth(\wolfs);

//



SynthDef(\perc1,{arg lol=1;Out.ar(0,
	a = InFeedback.ar(0,2);
	b = (Mix.fill(3,{arg lol;
		(Splay.ar((SinOscFB.ar(Sweep.kr(Dust.kr([10.tan,5.softclip]),10.0.rand)+rrand(50.0,70)**(lol.log), a.cosh, (1/(7+lol)).softclip) +
			SinOscFB.ar(Sweep.kr(Dust.kr([0.1,0.9]),10.0.rand)+200/((lol**lol)), a.tanh, (1/(8+lol)).softclip) +
			SinOscFB.ar([rrand(60,100),rrand(400,440)]**((lol**2).distort), a.distort, (1/(9+lol)))),2))
	}))*Pulse.ar([10.softclip+(Sweep.kr(Dust.kr(0.5),0.1.sinh)), 3.tanh+(Sweep.kr(Dust.kr(0.08),0.1.tanh))]);
	z = GVerb.ar(b,lol, 3, 0.8, 0.9, 2, maxroomsize:20)*0.01;
	y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.5,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y) * EnvGen.kr(Env.linen(1,15,2,1,\sin), doneAction:2)
)}).add;

Synth(\perc1);
Synth(\perc1, [\lol, (11.rand+2)]);


//


SynthDef(\TriBassi, {arg freq = 25.0; Out.ar(0,
	(

		z = GVerb.ar((Decay.kr(Impulse.kr(0),20)*LFTri.ar((39.8..43.3).rotate+(freq)).atan*0.1), 1, 20, 0.2, maxroomsize: 10);
		y = (Compander.ar(z, z,
        thresh: 0.1,
        slopeBelow: 1,
        slopeAbove: 0.3,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y*0.2) * EnvGen.kr(Env.linen(0.01,8,6,1,\sin), doneAction:2)

	)
)}).add;


Synth(\TriBassi, [\freq, (22.0.rand+1.93)]);

//


{SinOsc.ar(0, BPF.ar(Dust.ar(10.dup)*20000, LFNoise1.kr(10.dup,4e3,4e3), 0.1),0.2)}.play;

//

SynthDef(\treble,{Out.ar(0,

	p=Dust2.ar((5000.atan).dup,0.2);
	z = (Decay.kr(Dust.kr(0.5), 10)*
		(p+CombC.ar(p,0.4,LFTri.ar((TRand.kr(0.5,MouseY.kr(2,50,1),Dust.kr(MouseX.kr(1.2,100,1)))),0.2,0.2),-1e4)))*(0.004).cosh;
	y = (Compander.ar(z, z,
        thresh: 0.09,
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y) * EnvGen.kr(Env.linen(1,15,15,1,\sin), doneAction:2)
)}).add;

Synth(\treble);

//

SynthDef(\sineacid,{Out.ar(0,
	a = InFeedback.ar(0,2);
	z = (CombC.ar(FSinOsc.ar(((49.9..59.9).rotate),a,0.1), 2, LFNoise1.ar(((13.8389..19.0).rotate).atan*SinOscFB.ar((0.1..0.3).rotate,a).atan+12,0.5,1.4), 20))*0.28; //SínusSýra

	y = (Compander.ar(z, z,
        thresh: 0.09,
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y) * EnvGen.kr(Env.linen(5,12,12,1,\sin), doneAction:2)
)}).add;

Synth(\sineacid);

//


SynthDef(\perc2,{arg lol = 1.5, lol2 = 3;Out.ar(0,

	a = ((Gendy1.ar(2.2, 2.2, 2.2, 2.2, (50..58.0).rotate, (50..58.0).rotate, 0.6, 0.9, 10))
		* Pulse.ar([TRand.kr(1,5, Dust.kr(0.9)),TRand.kr(2,6, Dust.kr(1.1))]) * Decay.kr(Dust.kr(9),2))*0.05;

	z = (GVerb.ar((Resonz.ar(a, MouseY.kr(100,9000,1,0.4), 2)), [lol,lol2], MouseX.kr(1.0,10)))*0.6;

	y = (Compander.ar(z, z,
        thresh: 0.09,
        slopeBelow: 1,
        slopeAbove: 0.4,
        clampTime: 0.01,
        relaxTime: 0.01
	    ));
	(y) * EnvGen.kr(Env.linen(0.2,12,12,1,\sin), doneAction:2)

)}).add;

Synth(\perc2);
Synth(\perc2, [\lol, (10.0.rand+1), \lol2, (10.0.rand+1)]);

//

SynthDef(\routine,{Out.ar(0,
(
e = Env.linen(10, 1, 20);


			(FreeVerb.ar(mix: MouseY.kr(0, 1), room: MouseX.kr(0.0, 1.0), damp: MouseX.kr(0.0, 1.0),
			in:(LinPan2.ar(EnvGen.ar(e, doneAction: 2) *
					PMOsc.ar((2000.0.rand),(800.0.rand), Line.kr(0.0, 12.rand,9),0,0.1), 1.0.rand2)))

		)*FreeSelf.kr(Line.kr(-1, 0.1, 30));

)//routine
)}).add;



//

SynthDef(\byrjun,{Out.ar(0,
({
	x = (Mix.fill(2,

	{arg lol;

			RLPF.ar(

					(a=LFCub;RecordBuf.ar(InFeedback.ar+a.ar((TRand.kr(50,150,LFNoise1.kr(0.1)))*lol),b=Buffer.alloc(s,8e5));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1,0,5.5)),
				(20000.98), 1)


			*(1/(2+(lol*10)))
		}))
		* EnvGen.kr(Env.linen(0.05, 10, 20), doneAction:2)
})
)}).add;

Synth(\byrjun);

//
)







