o=s.options

o.memSize;

o.memSize = 2.pow(16);

//you could also do this

//o.memSize_(2.pow(16));

s.quit;

s.boot;

o.memSize;





(
a = Task({
    loop {
			0.05.wait;
		Synth(\silence).waitForFree;
            0.05.wait;
		Synth(\silence, [\freq, 435]).waitForFree;
		    0.05.wait;
		Synth(\silence).waitForFree;
		0.05.wait;
		Synth(\klang, [\freq, 435, \lol, 10]).waitForFree;
		0.05.wait;
}
}).play; //a4

//

b = Task({
    loop {
			0.05.wait;
		Synth(\silence, [\freq, 595]).waitForFree;
            0.05.wait;
		Synth(\bassi1).waitForFree;
		    0.05.wait;
		Synth(\silence, [\freq, 595]).waitForFree;
		0.05.wait;
		Synth(\bassi1, [\lol, 12.1, \lol2, 1]).waitForFree;
		0.05.wait;
}
}).play; //f6


//

c = Task({
    loop {
			0.05.wait;
		Synth(\silence, [\freq, 1590]).waitForFree;
            0.05.wait;
		Synth(\reverb).waitForFree;
		    0.05.wait;
		Synth(\silence, [\freq, 1590]).waitForFree;
		0.05.wait;
		Synth(\reverb, [\lol, 2, \volume, 1]).waitForFree;
		0.05.wait;
}
}).play; //fís3


//

d = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 2460]).waitForFree;
            0.05.wait;
		Synth(\motor, [\lol, rrand(0.1,1.5)]).waitForFree;
		    0.02.wait;
}
}).play; //c4 //byrja á þessu!


//

e = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 2737]).waitForFree;
            0.05.wait;
		Synth(\wolfs).waitForFree;
		    0.02.wait;
}
}).play; //g5


//

f = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 305]).waitForFree;
            0.05.wait;
		Synth(\perc1).waitForFree;
		    0.02.wait;
		Synth(\silence, [\freq, 305]).waitForFree;
		    0.05.wait;
		Synth(\perc1, [\lol, (11.rand+2)]).waitForFree;
}
}).play; //cís6


//

g = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 1248]).waitForFree;
            0.05.wait;
		Synth(\routine);

		    0.02.wait;
}
}).play; //d5



//

h = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 160]).waitForFree;
            0.05.wait;
		Synth(\perc2).waitForFree;
		    0.02.wait;
		Synth(\silence, [\freq, 160]).waitForFree;
		    0.05.wait;
		Synth(\perc2, [\lol, (10.0.rand+1), \lol2, (10.0.rand+1)]).waitForFree;
}
}).play; //dís6

//

j = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 295]).waitForFree;
            0.05.wait;
		Synth(\acid).waitForFree;
		    0.02.wait;
}
}).play; //e4

//

k = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 1008]).waitForFree;
            0.05.wait;
		Synth(\TriBassi, [\freq, (22.0.rand+1.93)]).waitForFree;
		    0.02.wait;
}
}).play; //gís3

//

l = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 1016]).waitForFree;
            0.05.wait;




		({x = (Mix.fill(2,

	{arg lol;

			RLPF.ar(

					(a=LFCub;RecordBuf.ar(InFeedback.ar+a.ar((TRand.kr(50,150,LFNoise1.kr(0.1)))*lol),b=Buffer.alloc(s,8e5));TGrains.ar(2,a ar:c=[3,2],b,a.ar(1/c)>0/2+1,0,5.5)),
				(20000.98), 1)


			*(1/(2+(lol*10)))
		}))
* EnvGen.kr(Env.linen(0.05, 10, 20), doneAction:2)}.play).waitForFree;





		    0.02.wait;
}
}).play; //aís5

//

m = Task({
    loop {
			0.03.wait;
		Synth(\silence, [\freq, 1170]).waitForFree;
            0.05.wait;
		Synth(\sineacid).waitForFree;
		    0.02.wait;
}
}).play; //h4
)


Synth(\silence, [\freq, 5000]) //TEST

Synth(\silence, [\freq, 435]) //a4 //klang //slá á efsta streng
Synth(\silence, [\freq, 595]) //f6 //bassi1 //láta viðinn hoppa á hliðinni
Synth(\silence, [\freq, 1590]) //fís3 //reverb //neðsti strengur fyrir ofan
Synth(\silence, [\freq, 2737]) //g5 //wolfs //efsti strengur fyrir ofan
Synth(\silence, [\freq, 2460]) //c4 //motor //strjúka efsta streng
Synth(\silence, [\freq, 305]) //cís6 //perc1 //slá með puttum á skrúfur
Synth(\silence, [\freq, 1248]) //d5 //routine //rétt svo snerta neðsta bandið, spila á efsta neðarlega á boga
Synth(\silence, [\freq, 160]) //dís6 //perc2 //önnur hendi dempar, hin slær neðst

Synth(\silence, [\freq, 295]) //e4 //acid //plokka næst efsta
Synth(\silence, [\freq, 1016]) //gís3 //tribassi //plokka efst á streng 2

Synth(\silence, [\freq, 1170]) //h4 //sineacid //plokka efst á streng 3

//neðsti stilltur í h, efsti í a, næst efsti í d


