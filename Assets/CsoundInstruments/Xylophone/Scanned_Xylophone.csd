<Cabbage>
form caption("Xylophone") size(1200, 500), guiMode("queue") pluginId("def1")
button bounds(30, 22, 80, 40) channel("trigger")
;===CABBAGE/TESTING CHANNELS===;
hslider bounds(32, 76, 150, 49) channel("duration") range(0, 10, 10, 1, 0.001) , 
hslider bounds(32, 142, 150, 50) channel("loudness") range(0, 80, 80, 1, 0.001)
hslider bounds(32, 208, 150, 50) channel("pitch") range(0, 8, 6.3, 1, 0.01)

;===UNITY CHANNELS===;
hslider bounds(212, 76, 150, 50) channel("mass") range(0, 12, 0, 1, 1) text("mass")
hslider bounds(214, 146, 150, 50) channel("displacement") range(0, 1, 0, 1, 0.001) text("dis")

hslider bounds(736, 24, 150, 28) channel("value1") range(0, 50, 7, 1, 0.01) text("Value 1")
hslider bounds(734, 54, 150, 30) channel("value2") range(0, 1000, 0, 1, 1) text("Value 2")
hslider bounds(736, 86, 150, 31) channel("value3") range(0, 2, 0, 1, 0.01) text("Value 3")
</Cabbage>
<CsoundSynthesizer>s
<CsOptions>
-n --displays -+rtmidi=NULL -M0 --limiter=.9  ; --midi-key-cps=5 --midi-velocity-amp=4
</CsOptions>
<CsInstruments>
;INSTRUMENT 1 = TRIGGER/SEND 
;INSTRUMENT 2 = SCANNED 
;INSTRUMENT 3 = HARMONIC/ATTACK 
;INSTRUMENT 4 = DISPLAYS
sr = 48000
ksmps = 32
nchnls = 2
0dbfs=1
massign 0, 3

kPortTime       linseg    0,0.01,0.1

gaScanSend      init    0
gaDisplaySend   init    0
gaSendM         init    0
gaSendL         init    0
gaSendR         init    0


;Tables
    giImp       ftgen    0,0,4097,9,0.5,1,0
    gidetuning  ftgen    0,0,128,21,1,1
    giDryMap    ftgen    0,0,4096,7,1,2048,1,2048,0   
    giWetMap    ftgen    0,0,4096,7,0,2048,1,2048,1
;Amplitude 
    gkAmpVel    init .5
    gkAmp       init .3
    gkNumOffset init 20.34
    gkNumRange  init 15
    gkNumOffset portk    gkNumOffset,kPortTime

;Detune
    gkdetune init 0

;Release Hammer:
    gkRelHammAmp init 0.1
    gkRelHammFrq init 200
    gkRelHammTrk init 0.3

;Harmonic
    gkHarmRange init 0.64
    gkHarmKybd init 0.00
    gkHarmOffset init 0.00
    ;   gliss
    gkHarmSlideDep init 0.00
    gkHarmSlideRate init .10
;Strings
    gkcutoff init 1.00
    gkfeedback init .99
    gkrelease init 4.00
;Impulse 
    gkHammFrq init 100
    gkHammTrk init 0.33
    gkToneVel init .750
;Stereo
    gkStWidth init 0.01
    gkStMix   init .5
    gkDryWet  init 0.300
;Reverb
    gkRvbEQ init 0.3
    gkRvbSize init 0.55
    

opcode    Oscil1a,a,iii                    
 iamp,ifrq,ifn    xin
 aptr    line    0,1/ifrq,1
 asig    tablei    aptr,ifn,1
 aenv    linseg    1,1/ifrq,1,0.001,0
    xout    asig*iamp*aenv
endop


instr 1         ;channel and trigger instrumnent 

	gkDry     table gkDryWet,giDryMap,1
    gkWet     table gkDryWet,giWetMap,1 
    
    kTrig  chnget "trigger"
    kDur   chnget "duration"
    kAmp   chnget "loudness"
    kPitch chnget "pitch"

    if changed(kTrig) == 1 then
        event "i", 2, 0, 10, -25, 6.06
        ;i "scan" 0 3 -14 6.00
    endif
endin

instr 3         ;Audio Signal Instrument (Harmonics)

    ;===Midi
    inum    notnum
    kcps        =    cpsmidinn(((inum/127) * gkNumRange) + gkNumOffset)
    
    ;===Hammer Release
    ;krel    release
    krel    init    0
    krms    init    0
    ktrig    trigger    krel,0.5,0
    if ktrig==1 then
        reinit RELEASE_HAMMER
    endif
    
    RELEASE_HAMMER:
    
        if i(krel)==1 then                            ; Insert release hammer values
            iAmpVel    =        i(gkRelHammAmp) * (( i(krms) * 3) + 0.03)
            ifrq        =        i(gkRelHammFrq) * semitone(i(gkRelHammTrk)*inum)
        else
            ifrq        =        i(gkHammFrq) * semitone(i(gkHammTrk)*inum)
            iAmpVel    veloc    1-i(gkAmpVel),1
        endif


        ;====Detuning
        idetune    table    70,gidetuning
        kdetune    =    idetune * gkdetune
    
    
        kPortTime    linseg    0,0.01,0.1
        gkNumOffset    portk    gkNumOffset,kPortTime

    
        ;===Impulse
        aImpls    Oscil1a iAmpVel, ifrq, giImp ;impulse of harmonics

    rireturn

    icf    veloc    12-(8*i(gkToneVel)),12
    aImpls    butlp    aImpls,cpsoct(icf)

    
     ;==Harmonic==
    iHarmVel    veloc    i(gkHarmRange),0
    iHarmKybd    =        (i(gkHarmKybd) * (128-inum))/128
    iHarmRatio    =        1 + i(gkHarmOffset) + iHarmVel + iHarmKybd
    kHarmRatio    =        1 + gkHarmOffset + iHarmVel + iHarmKybd
    kHarmRatio    init    iHarmRatio
    aHarmRatio    =        a(kHarmRatio)
 
    ;=====WaveGuide Frequencies
      
    aFund1      interp   kcps * cent(kdetune), 0, 1
    aFund2      interp   kcps * cent(-kdetune), 0, 1
    
    aHarmRatio    interp    kHarmRatio, 0, 1
    
     if gkHarmSlideDep>0 then
        aMod        rspline    -gkHarmSlideDep,gkHarmSlideDep,gkHarmSlideRate,gkHarmSlideRate*2
        aHarmRatio    =        aHarmRatio * semitone(aMod)
    endif
    
    aHarm1      =   aFund1 * aHarmRatio
    aHarm2      =   aFund2 * aHarmRatio
    
    kcutoff = 5000
    kfeedback = 2.499999 
  
    ;====WaveGuide Filters
    kcutoff    =        (sr/2)*gkcutoff
    kfeedback    =        0.249999999*gkfeedback
    aWg2        wguide2    aImpls,aFund1, aHarm1, kcutoff,kcutoff, kfeedback, kfeedback
    aWg2_2        wguide2    aImpls,aFund2, aHarm2, kcutoff,kcutoff, kfeedback, kfeedback
        
    aWg2    dcblock2    aWg2+aWg2_2
    icps    cpsmidi
    aWg2    butbr    aWg2, icps, icps*0.1
    krms    rms      aWg2
        
        
    ;=====Release
    irel    =        i(gkrelease)
    kCF    expsegr        sr/3,irel,20
    aEnv    expsegr        1,irel,0.01
    aWg2    tone        aWg2, kCF
    aWg2    =        aWg2 * aEnv  
    
    iScanSendAmt    =   2.0
    aScanSend      =   gaScanSend + (aWg2 * iScanSendAmt)
    gaSendM = gaSendM + aWg2
endin


instr 2         ;SCANNED instrument 
    a0 init 0
    
    kMass chnget "mass"
    kDisplace chnget "displacement"
    
    kcentend chnget "value1"
    kcentr   linseg 1, 1, 10, 1, 6, 2, 2
    kpos    linseg    0, 3, 1

    irate = .025
    
          ;init, irate, ifndisplace, ifnmass, ifnmatrix, ifncentr, ifndamp,     kmass,  kmtrxstiff, kcentr,      kdamp,       ileft,        iright,    kpos,      kdisplace,    ain,    idisp,  id 
        
    scanu2 1,   irate,  6,              2,      3,          4,      5,          30,       60,       kcentr,       .5,           .2,            .7,      kpos,       kDisplace,    gaScanSend, 1,  2
    
    a1 scans ampdbfs(p4), cpspch(p5), 7, 2, 4
    a1 dcblock a1
    ;===Enevelope===
    kHPenv  expseg  1, 4, 100, 6, 15000
    a1      buthp   a1, kHPenv
    
    ;===Filters===
    a1  atonex  a1, 25
    a1  tonex   a1, 6700, 2
    a1  butlp   a1, 10000

   ; a1  eqfil   a1, kCOch, kbw, kgain, 1
    ;===Outputs===
    iWet = .5
    iDry = .5
    gaSendM = gaSendM + (a1 * iWet)
    outs a1 * iDry, a1 * iDry
    clear gaScanSend
endin

instr    98    ; spatialising short delays

    iDelTimL    random    0.00001,i(gkStWidth)
    aDelSigL    delay    gaSendM, iDelTimL
    iDelTimR    random    0.00001,i(gkStWidth)
    aDelSigR    delay    gaSendM, iDelTimR
    kDry        table    gkStMix,giDryMap,1
    kWet        table    gkStMix,giWetMap,1
    aL        =    ((gaSendM*kDry)+(aDelSigL*kWet)) * gkDry
    aR        =    ((gaSendM*kDry)+(aDelSigR*kWet)) * gkDry
    gaSendL    =    gaSendL + gaSendM + aDelSigL
    gaSendR    =    gaSendR + gaSendM + aDelSigR
            outs    aL*gkAmp, aR*gkAmp
            clear    gaSendM
endin

instr    99
    kRvbLPF    limit    cpsoct(4+(gkRvbEQ*2*10)),20,sr/2    
    aL,aR    reverbsc    gaSendL,gaSendR,gkRvbSize,kRvbLPF
        outs        aL*gkWet*gkAmp,aR*gkWet*gkAmp
        clear        gaSendL,gaSendR
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z

; Initial displacement condition
;f1 0 128 -7 0 64 1 64 0 ; ramp
;f1 0 128 10 1
;f1 0 128 -7 0 28 0 11 1 11 0 78 0 ; a pluck that is 10 points wide on the surface
f1 0 128 -7 0 56 0 8 1 8 0 56 0 ;A CENTERED PLUCK! IT SOUNDS GREAT 
; Masses
f2 0 128 -7 .8 128 .5

; Spring satrices
f3 0 16384 -23 "string-128.matrxB"
;   .MATRX T
;f3 0 0 -44 "128,8-cylinder.XmatrxT"

; Centering force  
;f4 0 128 -7 .12 128 .5 ; 
f4 0 128 -11 2 .2 -.2

; Damping
f5 0 128 -7 1 128 .3
; Initial velocity - (displacement, vel, and acceleration
; Acceleration is from stiffness matrix pos effect - increases acceleration
;UN-UNIFORM TABlE: f% 0 128 9 1 .4 0 2.2 .5 0 3.8 1 0
;f6 0 128 9 1 .4 0 2.2 .5 0 3.8 1 0

;f6 0 128 -7 .03 128 .03; uniform initial velocity
f6 0 128 -11 1 1.5 -.2 ;same GEN11 as centering force
;f6 0 128 10 
; Trajectories
f7 0 128 -7 .01 128 128


;====Initialize Instruments
i1 0 [60*60*24*7]
i2 0 [60*60*24*7]
i3 0 [60*60*24*7]
i98 0 [60*60*24*7]
i99 0 [60*60*24*7]
i3 0 [60*60*24*7]
i 98 0 [3600*24*7]
i 99 0 [3600*24*7]
e
</CsScore>
</CsoundSynthesizer>





<bsbPresets>
</bsbPresets>
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
