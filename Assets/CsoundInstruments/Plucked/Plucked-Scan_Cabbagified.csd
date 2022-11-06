<Cabbage>
form caption("Plucked-Scan") size(400, 300), guiMode("queue") pluginId("def1")
button bounds(30, 22, 80, 40) channel("trigger")
hslider bounds(32, 76, 150, 49) channel("displace") range(0, 0.3, 0, 1, 0.01) text("displace"), 
hslider bounds(32, 142, 150, 50) channel("position") range(0, 1, 0.5, 1, 0.01) text("position"), 
hslider bounds(32, 208, 150, 50) channel("pitch") range(0, 8, 6, 1, 0.05) text("pitch"), 
hslider bounds(232, 74, 150, 50) channel("mass") range(0, 10, 0, 1, 0.01) text("mass")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 10
nchnls = 2
;0dbfs = 1

instr 1
    
    kTrig  chnget "trigger"
    
    kPitch chnget "pitch"
    
    
    
    if changed(kTrig) == 1 then
        event "i", 2, 0, 8, 80, 20, 40, 80, 100, 30
    endif
    
endin

	instr 2
	
kDisplace   chnget "displace"
kPosition   chnget "position"
kMassinput       chnget "mass"
    
a0 = 0
irate = .0005
kmass				= 4 + kMassinput
kmtrxstiff		= .4
kcentr				= .04
kdamp				= -.01
ileft				= .5
iright				= .5
;kpos				= .2
;kDisplace			= 0
ain					= a0

;scanu 	init, irate,   ifndisp,	 ifnmass, ifnmatrx, ifncentr, ifndamp, kmass, kmtrxstiff, kcentr, kdamp, ileft, iright, kpos, kdisplace, ain, idisp, id 

scanu 		1, irate,		6, 		2, 			3, 			4, 			5,		 kmass,		 kmtrxstiff,	kcentr, kdamp, 	ileft, iright, kPosition, kDisplace, ain, 	1, 		2


;---pitch values---;
;ipitchpoint1 randomh 15, 40, 10, 3
;ipitchpoint2 randomh 30, 70, 10, 3
;ipitchpoint3 randomh 80, 130, 10, 3
;ipitchpoint4 randomh 20, 80, 10, 3

kbentpitch linseg p5, 1, p6, .5, p7, .2, p8


kpitchlfo oscil 2, 4

a1  scans ampdb(p4), kbentpitch + kpitchlfo, 7,       2
					outs a1, a1
					endin
</CsInstruments>
<CsScore>
;causes csound to run for 7000 years
f0 z
; Initial condition
f1 0 128 -7 0 64 .5
   
; Masses
f2 0 128 -7 .1 128 .9
   
; Spring matrices
f3 0 16384 -23 "string-128.matrxB"
   
; Centering force
f4  0 128 -7 1 128 3
   
; Damping
f5 0 128 -7 1 96 2 32 0.4
   
; Initial velocity
f6 0 128 -10 .5
   
; Trajectories
f7 0 128 -5 .001 128 128

;score
;example hit:
;   strt    dur         db      pitch
;i1 0       10          80      6.00

;run csound forever
i1 0 [60*60*24*7] 




</CsScore>
</CsoundSynthesizer>






















<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
