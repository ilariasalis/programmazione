import("stdfaust.lib");
fader = vslider ("[01]", -70., -70., +12., 0.1) : ba.db2linear : si.smoo ;
panpot = vslider ("[01]panpot [style:knob]", 0.5, 0.0, 1.0, 0.01);
vmeter(x) = attach (x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))
with{
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
} ;
process = _ <: * (1-panpot), * (panpot) : hgroup ("meters [2]", * (fader), * (fader) : vmeter, vmeter) ; 
