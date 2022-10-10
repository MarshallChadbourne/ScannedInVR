<Cabbage> bounds(0, 0, 0, 0)
form caption("Untitled") size(800, 500), guiMode("queue"), pluginId("def1")
button bounds(302, 4, 80, 40) channel("trigger")

hslider bounds(6, 122, 150, 50) channel("displace") range(0, 5, 0, 1, 0.01) text("displace")

hslider bounds(6, 150, 150, 50) channel("position") range(0, 1, 0, 1, 0.01) text("position")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-d -n
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 32767


;========== Spinning Pendulum around Clock v01 ==========;
; Takahiko Tsuchiya, Summer 2011
; Please be warned that the scanned synth in this piece is not completely stable.
; Your headphones / speakers may explode.


;========== global variables ==========;
gitempo		=		20
garvbl		init	0
garvbr		init	0
gadlyl		init	0
gadlyr		init	0
turnon		21
turnon		22


;========== f-tables ==========;
ginitp		ftgen	1, 0, 128, 7, 0, 64, 1, 64, 0
gintvl		ftgen	2, 0, 128, -7, 0, 128, 0
gimass		ftgen	3, 0, 128, -7, 1, 128, 1
gicntf		ftgen	4, 0, 128, -7, 0, 128, 2
gidamp		ftgen	5, 0, 128, -7, 1, 128, 1
gitrjc		ftgen	6, 0, 128, -5, .001, 128, 128
gispmt1	ftgen  7, 0, 16384, -23, "128-string"
gispmt2	ftgen	8, 0, 16384, -23, "128-stringcircular"
gisine		ftgen	9, 0, 4096, 10, 1
gisaw		ftgen	10, 0, 4096, 7, -1, 4096, 1
gibisq		ftgen	11, 0, 512, 7, -1, 256, -1, 0, 1, 256, 1


;========== instruments ==========;
			instr 1 ; scanned synth harm voices
irate		=		rnd(.05)+.005
kmass		=		2
kstfev		expseg	1, rnd(.3), rnd(1), rnd(1)+10, 2
kstiff		=		0.1;irate*kmass*kstfev
kcntrf		=		0.1;irate*kmass*rnd(1)
kdamp		=		-0.01
ileft		=		.1
iright		=		.5
;--------edit made------------;
;swapped both kx and ky for input channels ranging from 1-2
kPosition   chnget  "position"
;kx			=		0
kDisplace   chnget  "displace"
;ky			=		0
;-----------------------------;
ain			=		0

idisp		=		0
			scanu	1, irate, 2, 3, 7, 4, 5, kmass, kstiff, kcntrf, kdamp, \
					ileft, iright, kPosition, kDisplace, ain, idisp, 1
			scanu	1, irate, 2, 3, 8, 4, 5, kmass, kstiff, kcntrf, kdamp, \
					ileft, iright, kPosition, kDisplace, ain, idisp, 2

iamp		=		ampdbfs(0)
kaenv		madsr	2, 0, 1, .5
iampsc		=		p6
kamp		=		iamp*kaenv*iampsc
ifrq1		=		cpspch(p4)
ifrq2		=		cpspch(p5)
idur		=		(p3*60/gitempo/2)/2 - 0.2
itransit	=		p3*60/gitempo * .02
klfoamp		=		.2
klfo		oscil	klfoamp, .5, 9
kfrq		expseg	ifrq1, idur, ifrq1, itransit, ifrq2, idur, ifrq2
asig1		scans	kamp, kfrq+klfo, 6, 1
asig2		scans	kamp, kfrq+klfo, 6, 2	

ilpfqcnt	=		400+rnd(100)
klpev		madsr	1, .5, .7, 1
klpflw		=		p4-7
klplfo		oscil	.1, .15, 9
klpfrq		=		ilpfqcnt*klpev*klpflw*(klplfo+1)
asig1		butlp	asig1, klpfrq
asig2		butlp	asig2, klpfrq
asig1		butlp	asig1, klpfrq
asig2		butlp	asig2, klpfrq

kbrfrq		=		450
kbrbd		=		600
asig1		butbr	asig1, kbrfrq, kbrbd
asig2		butbr	asig2, kbrfrq, kbrbd

ipan		=		rnd(1)
kpan		expseg	ipan, p3*60/gitempo, 1-ipan
asig1		clip	asig1, 0, 32767
asig2		clip	asig2, 0, 32767
			outs	asig1*kpan, asig2*(1-kpan)
;--------edit made------------;
;turning delay from .8 to .4 to hear effect more clearly
idlysnd		=		.4
gadlyl		=		gadlyl + (asig1*idlysnd)
gadlyr		=		gadlyr + (asig2*idlysnd)
;turning rvb from .9 to .5
irvbsnd		=		.5
garvbl		=		garvbl + (asig1*irvbsnd)
garvbr		=		garvbr + (asig2*irvbsnd)
			endin



			instr 4 ; bass
kgain		=		ampdbfs(-30)
kampenv		madsr	8, 0, 1, 8
kalfo		oscil	0.3, .1, 9
kamp		=		kgain * kampenv*(kalfo+1)
ifrq		=		cpspch(p4)
idetune		=		1.005
asig1		oscil	kamp, ifrq/idetune, 10
asig2		oscil	kamp, ifrq*idetune, 10
asig3		oscil	kamp, ifrq/2, 9
asig1		=		asig1 + asig3
asig2		=		asig2 + asig3

ilpfq		=		450
klpev		madsr	1.5, .5, .7, 1
asig1		butlp	asig1, ilpfq*klpev
asig2		butlp	asig2, ilpfq*klpev
asig1		butlp	asig1, ilpfq*klpev
asig2		butlp	asig2, ilpfq*klpev

asig1		clip	asig1, 0, 32767
asig2		clip	asig2, 0, 32767
			outs	asig1, asig2
			
idlysnd		=		.8
gadlyl		=		gadlyl + (asig1*idlysnd)
gadlyr		=		gadlyr + (asig2*idlysnd)
irvbsnd		=		.8
garvbl		=		garvbl + (asig1*irvbsnd)
garvbr		=		garvbr + (asig2*irvbsnd)
			endin


;========== effects ==========
			instr 21 ; delay
ilpt		=		60/gitempo*.1		; delay time (cycle)
irvbt		=		10		; feedback
adly1		comb	gadlyl, irvbt, ilpt
adly2		comb	gadlyr, irvbt, ilpt
adly1		clip	adly1, 0, 32767
adly2		clip	adly2, 0, 32767
			outs	adly1, adly2
gadlyl		=		0
gadlyr		=		0

isndrvb		=		0
garvbl		=		garvbl + (adly1*isndrvb)
garvbr		=		garvbr + (adly2*isndrvb)
			endin

			instr 22 ; verb
arvb1, arvb2 	freeverb garvbl, garvbr, .95, .1
arvb1		clip	arvb1, 0, 32767
arvb2		clip	arvb2, 0, 32767
			outs	arvb1, arvb2
garvbl		=		0
garvbr		=		0
			endin



</CsInstruments>
<CsScore>
;f0	99
t	0	20	; BPM

;		dur	pitch1	pitch2	amp
i1	0	0	8.12	8.11	0
i.	+	.
i.	.	2	.		.		.5
i.	.	1	.		.		.8
i.	.	1	.		.		<
i.	.	2	.		.		1
i.	.	3	.		.		<
i.	.	5
i.	.	8
i.	.	13	.		.		.5
i.	.	8	.		.		<
i.	.	5
i.	.	3
i.	.	2	8.11	8.12
i.	.	1	.		.		1
i.	.	1	.		.		<
i.	.	2
i.	.	3
i.	.	5
i.	.	8
i.	.	13	.		.		.6




i1	0	0	8.07	8.08	0
i.	+	.
i.	.	5	.		.		.06
i.	.	3	.		.		<
i.	.	2
i.	.	1	.		.		.7
i.	.	1	.		.		<
i.	.	2
i.	.	3	.		.		.9
i.	.	5	.		.		<
i.	.	8
i.	.	13	.		.		.5
i.	.	8	8.08	8.07	<
i.	.	5
i.	.	3
i.	.	2
i.	.	1	.		.		1
i.	.	1
i.	.	2
i.	.	3
i.	.	5
i.	.	8


i1	0	0	8.04	8.03	0
i.	+	.
i.	.	13	.		.		.6
i.	.	8	.		.		<
i.	.	5
i.	.	3
i.	.	2
i.	.	1	.		.		.9
i.	.	1	.		.		<
i.	.	2
i.	.	3
i.	.	5	.		.		.5
i.	.	8	.		.		<
i.	.	13	9.03	9.04	.7
i.	.	8	.		.		<
i.	.	5
i.	.	3
i.	.	2	.		.		.9
i.	.	1
i.	.	1
i.	.	2
i.	.	3


i4	0	0	1.00
i.	+	.
i.	.	11	7.12
i.	.	.	7.08
i.	.	.	7.04
i.	.	.	6.12
i.	.	.	6.08
i.	.	.	6.04
i.	.	.	6.00


</CsScore>
</CsoundSynthesizer>









<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>72</x>
 <y>179</y>
 <width>400</width>
 <height>200</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>125</r>
  <g>162</g>
  <b>160</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>amp</objectName>
  <x>266</x>
  <y>7</y>
  <width>20</width>
  <height>98</height>
  <uuid>{b0295110-06b6-4917-91f3-9203813bd237}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.12244900</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBHSlider" version="2">
  <objectName>freq</objectName>
  <x>10</x>
  <y>29</y>
  <width>239</width>
  <height>22</height>
  <uuid>{c0d9ee04-927d-403a-9be4-fadc72b5f8fc}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <minimum>100.00000000</minimum>
  <maximum>1000.00000000</maximum>
  <value>258.15899600</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBGraph" version="2">
  <objectName/>
  <x>8</x>
  <y>112</y>
  <width>265</width>
  <height>116</height>
  <uuid>{6f32c2d6-8040-413c-96b6-7b29bbc1f52c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>auto</modex>
  <modey>auto</modey>
  <showSelector>true</showSelector>
  <showGrid>true</showGrid>
  <showTableInfo>true</showTableInfo>
  <showScrollbars>true</showScrollbars>
  <enableTables>true</enableTables>
  <enableDisplays>true</enableDisplays>
  <all>true</all>
 </bsbObject>
 <bsbObject type="BSBConsole" version="2">
  <objectName/>
  <x>279</x>
  <y>112</y>
  <width>266</width>
  <height>266</height>
  <uuid>{9621eabb-8240-4aef-be47-c40fe25b727c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <font>Courier</font>
  <fontsize>8</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>293</x>
  <y>44</y>
  <width>41</width>
  <height>24</height>
  <uuid>{0134dca8-3adc-459d-9bf3-ee1647a05770}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Amp:</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>amp</objectName>
  <x>333</x>
  <y>44</y>
  <width>70</width>
  <height>24</height>
  <uuid>{e14e839b-140f-4167-a9bc-5940ac6a5a11}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>0.1837</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>66</x>
  <y>57</y>
  <width>41</width>
  <height>24</height>
  <uuid>{dc3ce546-31e2-4059-9511-457c71af1925}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Freq:</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>freq</objectName>
  <x>106</x>
  <y>57</y>
  <width>69</width>
  <height>24</height>
  <uuid>{82b6e7a5-fd5a-46a6-80f4-881dd7afebb5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>261.9247</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>425</x>
  <y>6</y>
  <width>120</width>
  <height>100</height>
  <uuid>{460f61c9-a2ca-4a9d-ae74-c52f54dcf472}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label/>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>freqsweep</objectName>
  <x>449</x>
  <y>68</y>
  <width>78</width>
  <height>24</height>
  <uuid>{3c0fc91e-ace4-4b56-b287-5a846cc6dfc7}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>999.6769</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>DejaVu Sans</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>55</r>
   <g>122</g>
   <b>116</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Button 1</objectName>
  <x>435</x>
  <y>24</y>
  <width>100</width>
  <height>30</height>
  <uuid>{ca57add2-56d4-4973-9582-c6316ea067a5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Sweep</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>false</latch>
  <momentaryMidiButton>false</momentaryMidiButton>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBScope" version="2">
  <objectName/>
  <x>8</x>
  <y>233</y>
  <width>266</width>
  <height>147</height>
  <uuid>{136cc7d0-c943-49b7-833e-1bea3e993f51}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>-255.00000000</value>
  <type>scope</type>
  <zoomx>2.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <mode>0.00000000</mode>
  <triggermode>NoTrigger</triggermode>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="0" y="0" width="596" height="322" visible="false" loopStart="0" loopEnd="0">    </EventPanel>
