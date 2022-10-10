<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue"), pluginId("def1")
keyboard bounds(8, 158, 381, 95)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

;instrument will be triggered by keyboard widget
instr 2
a0 init 0

kEnv madsr .1, .2, .6, .4

irate = .01
kpos line 0, p3, 128

scanu2 1, irate, 6, 2, 3, 4, 5, 2, 9, .01, .01, .1, .9, 0, 0, a0, 0, 2


a1 scans ampdb(p5), cpspch(p4), 7, 2

;aOut vco2 p5, p4

outs a1, a1
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z

; Initial displacement condition
;f1 0 128 -7 0 64 1 64 0 ; ramp
f1 0 128 10 1 ; sine hammer
;f1 0 128 -7 0 28 0 2 1 2 0 96 0 ; a pluck that is 10 points wide on the surface

; Masses
f2 0 128 -7 1 128 1

; Spring matrices
f3 0 16384 -23 "string-128.matrxB"

; Centering force
f4 0 128 -7 1 128 20 ; uniform initial centering
;f4 0 128 -7 .001 128 1 ; ramped centering

; Damping
f5 0 128 -7 1 128 10 ; uniform damping
;f5 0 128 -7 .1 128 1 ; ramped damping

; Initial velocity - (displacement, vel, and acceleration
; Acceleration is from stiffness matrix pos effect - increases acceleration
;

f6 0 128 -7 .01 128 1 ; uniform initial velocity

; Trajectories
f7 0 128 -5 .001 128 128
</CsScore>
</CsoundSynthesizer>
