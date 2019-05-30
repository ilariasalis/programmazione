import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5));

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;

frq = vslider("[01] f1 [style:knob]", 440,100,20000,1); 

panfadg(x) = vgroup("[01]", x);

pan = panfadg(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo);

vol = panfadg(vslider("[02] vol1 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo);

oscill(o) = os.oscsin(frq*1) : hgroup("[02] OSC %o", * (vol) <: * (sqrt(1-pan)), * (sqrt(pan)) : vmeter, vmeter); 

process = hgroup("OSCILLATORS BANK", par(i, 8, oscill(i)));
//numerazione a tre cifre
//stereo out	
//moltiplicazioni per o
