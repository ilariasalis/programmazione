import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))
  with{
  envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
};

frq = vslider("[01] f1 [style:knob]", 440,100,20000,1); 


oscill(o) = os.oscsin(frq*ooo) : hgroup("[02] OSC %ooo", * (vol) <: * (sqrt(1-pan)), * (sqrt(pan)) : vmeter, vmeter) 
  with{  
   ooo = o +(001);
  panfadg(x) = vgroup("[01]", x);
  pan = panfadg(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo);
  vol = panfadg(vslider("[02] vol1 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo);
}; 

stereo = *vol, *vol
  with{
  
}
  
process = hgroup("OSCILLATORS BANK", par(i, 16, oscill(i))) :> _,_;
//ordine oscillatori
//volume out	
