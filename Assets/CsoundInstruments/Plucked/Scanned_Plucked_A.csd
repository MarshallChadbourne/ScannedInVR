<Cabbage>
form caption("Plucked-Scan") size(400, 300), guiMode("queue") pluginId("def1")
button bounds(30, 22, 80, 40) channel("trigger")
hslider bounds(32, 76, 150, 49) channel("duration") range(0, 10, 10, 1, 0.001) text("duration"), 
hslider bounds(32, 142, 150, 50) channel("loudness") range(0, 80, 80, 1, 0.001) text("loudness"), 
hslider bounds(32, 208, 150, 50) channel("pitch") range(, 8, 6, 1, 0.05) text("pitch"), 

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 16
nchnls = 2
;0dbfs = 1

instr 1
    
    kTrig  chnget "trigger"
    kDur   chnget "duration"
    kAmp   chnget "loudness"
    kPitch chnget "pitch"
    
    if changed(kTrig) == 1 then
        event "i", 2, 0, kDur, kAmp, kPitch
    endif
    
endin
    
	instr 2

    
a0 = 0
irate = .0005
kmass				= 4
kmtrxstiff		= .4
kcentr				= .04
kdamp				= -.01
ileft				= .5
iright				= .5
kpos				= .2
kdisplace			= 0
ain					= a0

;scanu 	init, irate, ifndisp,	ifnmass, ifnmatrx, ifncentr, ifndamp, kmass, kmtrxstiff, kcentr, kdamp, ileft, iright, kpos, kdisplace, ain, idisp, id 

scanu 		1, irate,		6, 			2, 			3, 			4, 			5,		 kmass,		 	kmtrxstiff,	kcentr, kdamp, 	ileft, iright, kpos, kdisplace, ain, 	1, 		2

kpitchbend linseg 20, 1, 40, .5, 100, .2, 20

a1  scans ampdb(p4), kpitchbend, 7,       2
					outs a1, a1
					endin
</CsInstruments>
<CsScore>
;causes csound to run for 7000 years
f0 z
; Initial condition
f1 0 128 -7 0 64 .5
   
; Masses
f2 0 128 -7 0.1 128 .9
   
; Spring matrices
f3 0 16384 -23 "string-128.matrxB"
   
; Centering force
f4  0 128 -7 1 128 3
   
; Damping
f5 0 128 -7 1 96 2 32 1
   
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
