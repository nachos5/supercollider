play{a=SinOscFB;Splay.ar(a.ar(13*13*b=(1..3),1/3)*a.ar(b/13,1)/13+a.ar(a.ar(1/(13..3))+133*b,a.ar(b/333,a.ar(b,1)%1)%1))/3}// #SuperCollider


play{a=LFSaw;a.ar((b=a.ar(1/3))+1**a.ar(b)*(99+c=[0,1]))%a.ar(b*99,c)%a.ar(1/32)+a.ar(a.ar(b)*4e4%2e3,0,a.ar(6,c)>0.9/2)/2}// #SuperCollider

play{Splay.ar({Pluck.ar(BPF.ar(f=product({|i|product({LFPulse.ar(2**2.rand2,2.rand/2)}!(i+2))/(1+i)+1}!8)*86,43).sin,Saw.ar,1,1/f,9)}!9)}

play{{a=SinOsc;l=LFNoise2;a.ar(666*a.ar(l.ar(l.ar(0.5))*9)*RLPF.ar(Saw.ar(9),l.ar(0.5).range(9,999),l.ar(2))).cubed}!2} //oscillators argue

play{n=Duty;AllpassC.ar(LFTri.ar(n.kr(0.1,0,Dseq([999,99,4000],inf)),0,1)*Dust.kr(n.kr(1,0,Dseq([1,5],inf))),0.2,0.02,1)!2}// #SuperCollider
)
play{a=SinOsc.ar(LFNoise0.ar(10).range(100,1e4),0,0.05)*Decay.kr(Dust.kr(1));GVerb.ar(a*LFNoise1.ar(40),299,400,0.2,0.5,50,0,0.2,0.9)}//#sc ÓGÓ FLOTT VERB

{n=LFNoise0.ar(_);f=[60,61];tanh(BBandPass.ar(max(max(n.(4),l=n.(6)),SinOsc.ar(f*ceil(l*9).lag(0.1))*0.7),f,n.(1).abs/2)*700*l.lag(1))}.play //bassi

play{a=VarSaw;Splay ar:a.ar(Select.ar(a.ar(2.01/b=[0,3,7,5,2,9,10]+0.2)*8,(c=a.ar(0.5/b))>0*12+b+48).midicps,0,c%1).tanh/2}// #SuperCollider VIBES

play{a=SinOscFB;GVerb.ar(mean(FreqShift.ar(c=a.ar(a.ar(a.ar(99/b=(1..9),1),1/b)+b*50,1),1/b)+c)/3,200,3,0.5,0.5,9,1,0.7,1)}//O MAN

play{a=SinOsc;GVerb.ar(sum(RHPF.ar(a.ar(3.5-b=(8..2),a.ar(4/b)*99)>0*a.ar(b*99)*(9-b),a.ar(1/b/2)+2*666,0.4)).tanh/5,99,2)}// #SuperCollider

play{a=SinOscFB;LocalOut kr:d=a.ar(Duty.kr(LocalIn kr:8,a.kr(1/16,1),Dseq((1..8)*50,inf)),a.kr(1/(1..8))+1/2);Splay ar:d/2}// #SuperCollider

play{a=SinOsc;b=Spring;c=a.ar((4..2)/64)%1;CombN ar:a.ar(0,b.ar(b.ar(b.ar(a.ar([2,3])>0,4,c@0/4),9,c@1/3),24,c@2/3)*9)*0.7}// #SuperCollider KÚL PULSE HOPP

play{a=Blip;GVerb.ar(HPF.ar(a.ar(a.ar(1/4,8).ceil+1*[99,9])*a.ar(1.01,ceil(2**a.ar(1/16)*4))>(a.ar(1/128)/4),9)/9,9,2,0.9)}// #SuperCollider Í BÚÐ LOL

play{a=SinOscFB;Splay.ar(a.ar(a.ar(b=1/(2..6),1)<b*500+99)/5+a.ar(999*b,a.ar(a.ar(b,1)<0.1+1,1)%b,a.ar(0.1-b,1).min(0)))/2}// #SuperCollider töff Harmónía

play{a=LFTri;l=LocalBuf(c=99,20).clear;RecordBuf.ar(a.ar(c=(1..20)),l);GVerb.ar(HPF.ar(IndexL.ar(l,a.ar(c/45)).sum,9)/9,1)}// #SuperCollider deffo töff

play{a=LFTri;l=LocalBuf(b=600,9).clear;BufWr.ar(a.ar(c=(3..11)*3.5),l,a.ar(9/c,c/99)*b);Splay.ar(PlayBuf.ar(9,l,loop:1)/2)}// #SuperCollider

a=SinOsc;play{d=BufRd.ar(2,b=LocalBuf(c=2e5,2).clear,a.ar([2,3]*9)*c,0);BufWr.ar(a.ar(3/[2,3])/3,b,a.ar([99,145]).abs*c);d}// #SuperCollider

a=SinOsc;play{tanh((c=InFeedback.ar(0,2))+HPF.ar(a.ar(b=1/[5,4],a.ar(a.ar(b*1.1,a.ar(b*2))+a.ar(b*1.4,c,5,4).ceil*99)),9))}// #SuperCollider Úlfar

play{{|i|RecordBuf.ar(Limiter.ar(HPF.ar(Warp1.ar(1,b=LocalBuf(9e3).clear,c=LFSaw.ar(d=1.0009,i).max,1/d)+(c>0/3),9)),b)}!2}// #SuperCollider FEEDBACK

a=LFCub;play{RecordBuf.ar(InFeedback.ar+a.ar(99),b=Buffer.alloc(s,8e4));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1.5,0,3)}// #SuperCollider BÚTÍFÚL FYRSTI KÓÐINN

play{a=LFSaw;c=(2..22)*99;b=999/c;Splay.ar(MoogFF.ar(a.ar(b*99*a.ar(b*9*a.ar(a.ar(b/9)*b))),(d=a.ar(9/c,9/c))+2*c,d+2.99))}// #SuperCollider SUÐ

play{a=LFSaw;Splay.ar(BLowPass4.ar(b=a.ar(a.ar(c=3/(1..12),d=c/3*2,99/c+99,900+c)),c*999+a.ar(c),a.ar(c,d)%1+0.01*2)).tanh}// #SuperCollider AYY LMAO

play{a=LFTri;b=(1..11).rotate(4)*1.011;LeakDC.ar(Splay.ar(Sweep.ar(0,b+999).fold(a.ar(11.11/b)/2-0.5,a.ar(11.1/b)/2+0.5)))}// #SuperCollider

//EINA LEIÐIN TIL AÐ LÁTA HÆTTA MEÐ MELÓDIKU ER AÐ GERA FREESELF MEÐ NÁKVÆMU PITCHI

({Mix.fill(rrand(4,8),

	{arg lol;
		(a=LFCub;RecordBuf.ar(InFeedback.ar+a.ar(rrand(30,500)*lol),b=Buffer.alloc(s,8e4));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1,0,6.0.rand))*(1/(2+(lol*10)))
	}

)}.play) //byrjunardót, finna eitthvað með músina







(
SynthDef(\UGen_ex6, {arg gate = 1, roomsize = 200, revtime = 450;
	var src, env, gverb;
	env = EnvGen.kr(Env([0, 1, 0], [1, 4], [4, -4], 1), gate, doneAction: 2);
	src = Resonz.ar(
			Array.fill(4, {Dust.ar(6)}),
			1760 * [1, 2.2, 3.95, 8.76] +
				Array.fill(4, {LFNoise2.kr(1, 20)}),
			0.01).sum * 30.dbamp;
	gverb = GVerb.ar(
		src,
		roomsize,
		revtime,
		// feedback loop damping
		0.99,
		// input bw of signal
		LFNoise2.kr(0.1).range(0.9, 0.7),
		// spread
		LFNoise1.kr(0.2).range(0.2, 0.6),
		// almost no direct source
		-60.dbamp,
		// some early reflection
		-18.dbamp,
		// lots of the tail
		3.dbamp,
		roomsize);
	Out.ar(0, gverb * env)
}).add;
)
a = Synth(\UGen_ex6);

a.release;