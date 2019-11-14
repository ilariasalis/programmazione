import("stdfaust.lib");

fader = vslider ("[01]volume", -70., -70., +12., 0.1) : ba.db2linear : si.smoo ;

panpot = vslider ("[02]panpot [style:knob]", 0.5, 0.0, 1.0, 0.01);

vmeter(x) = attach (x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))

with{
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
} ;

pmode = nentry("[01] pan mode [style:menu{'Linear':0; 'Exponential':1}]", 0, 0, 1, 1) : int;

process = _ <: 
             * (1-panpot), * (sqrt(1-panpot)), // left lineare, left quadratico
             * (panpot), * (sqrt(panpot)) : // right lineare, right quadratico 
             ba.selectn(2, pmode), //selettore sinistro
             ba.selectn(2, pmode) : //selettore destro
             hgroup ("meters [03]", * (fader), * (fader) : vmeter, vmeter) ;  
