.audio
Fx_FLT_RTFM:
; A4 stores first argument to function, it seems here it holds a structure
; load from structure using offsets
           LDW.D1T2      *A4[1],B4   ; "parameters" are loaded as offset from this address
           LDW.D1T1      *A4[12],A7  ; some source that is always loaded from, with increment
           LDW.D1T1      *A4[11],A6  ; some destination that is always written to
           LDW.D1T1      *A4[6],A9   ; address of Output, see how it is loaded to understand
           LDW.D1T1      *A4[5],A5   ; address of FxIn, see how it is loaded to understand
           LDW.D1T1      *A4[4],A8   ; address of GuitarIn, see how it is loaded to undestand

; using B4, load:
           LDW.D2T2      *B4[4],B9   ; probably knob level multiplier so that 100 on knob means 1.0 as float
           LDW.D2T2      *B4[5],B5   ; left knob value multiplier
           LDW.D2T2      *B4[6],B6   ; right knob value multiplier
           LDW.D2T2      *B4[0],B8   ; effect on/off multiplier, 1.0 when on, 0.0 when off

; while these are loading, busy with housekeeping
           LDW.D1T1      *A6[0],A6   ; prepare sink address, this logic is from inspiration
 ||        MVK.L2        0,B7        ; set B7 to 1.0 step 1
           SUBAW.D1      A9,0x8,A9   ; decrement "Output" offset because each loop start with increment of it
           SUBAW.D1      A5,0x8,A5   ; decrement "FxIn" offset because each loop start w
 ||        SET.S2        B7,23,29,B7 ; set B7 to 1.0 step 2
 ||        MVK.L2        2,B0        ; prepare loop count

; do calculations that need to be done once only
           MPYSP.M2      B5,B9,B5    ; adjusted left knob level
           NOP           3
           MPYSP.M2      B6,B9,B6    ; adjusted right knob level
           NOP           3
           SUBSP.L2      B7,B8,B7    ; make B7 into 1.0 - effect on/off, 0.0 when on, 1.0 when off

; iterate over left and right channels (buffers)
; order is left, right
$C$L1:
; instead of nop 3
           LDW.D1T1      *A7[0],A4   ; this will be read 0,1,2 ... 7
           NOP           4
           STW.D1T1      A4,*A6[0]   ; but always written to 0; this step is logic from inspiration

; housekeeping for each iteration
           LDW.D1T2      *++A9[8],B9 ; increment address, value not used
 ||        ADD.L2        B0,-1,B0    ; decrement loop counter

           LDW.D1T1      *++A5[8],A3 ; increment address, read FxIn
           LDW.D1T1      *A8[0],A4   ; TODO investigation - why GuitarIn buffer is consumed twice? is this a bug in the original? increment needed?
           NOP           3

; comments below are written as if FX is on, mode is "L is universal", B8 is 1.0 and B7 is 0.0
; for "R is universal", B8 and B7 are swapped, but 2nd set of comments will be even more confusing
           ; enablers
           MPYSP.M1X     A3,B8,A3    ; prev.in x enabled -LR-> prev.in / 0
           NOP           3
           MPYSP.M1X     A4,B7,A4    ; dry x disabled    -LR-> 0       / dry
           NOP           3

           ; volume, B5 is used as volume, and starts with volume left; set to volume right at the end of unroll
           MPYSP.M1X     A3,B5,A3    ; prev.in / 0 x volume   -LR-> prev.in' / 0
           NOP           3
           MPYSP.M2X     B5,A4,B9    ; 0       / dry x volume -LR-> 0        / dry'
           NOP           3

           ; write to buffers
           STW.D1T1      A3,*A9[0]   ; prev.in' / 0    -> output   =LR=> prev.in' / 0
           STW.D1T2      B9,*A5[0]   ; 0        / dry' -> next fx  =LR=> 0        / dry'
           STW.D1T1      A4,*A8[0]   ; 0        / dry  -> next dry =LR=> 0        / dry

; on left  channel, output is hard set (no tails) to what was processed before this fx
; on left  channel, next fx receives zero as output from this fx
; on left  channel, next fx receives zero as instrument input
; on right channel, output is set to 0, remove any tails from previous
; on right channel, next fx receives instrument input as output from this fx
; on right channel, next fx receives instrument input as instrument input

; on left  channel, left volume is applied to output and next fx in
; on right channel, right volume is applied to output and next fx in

; and now repeat above for index 1
; structure in inspiration is clearly a result of loop unroll
; but rolling it back required using registers as offset for other registers
; and that is way too complex for this excersise
           LDW.D1T1      *A7[1],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[1],A3
           LDW.D1T1      *A8[1],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[1]
           STW.D1T2      B9,*A5[1]
           STW.D1T1      A4,*A8[1]


           LDW.D1T1      *A7[2],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[2],A3
           LDW.D1T1      *A8[2],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[2]
           STW.D1T2      B9,*A5[2]
           STW.D1T1      A4,*A8[2]


           LDW.D1T1      *A7[3],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[3],A3
           LDW.D1T1      *A8[3],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[3]
           STW.D1T2      B9,*A5[3]
           STW.D1T1      A4,*A8[3]


           LDW.D1T1      *A7[4],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[4],A3
           LDW.D1T1      *A8[4],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[4]
           STW.D1T2      B9,*A5[4]
           STW.D1T1      A4,*A8[4]


           LDW.D1T1      *A7[5],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[5],A3
           LDW.D1T1      *A8[5],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[5]
           STW.D1T2      B9,*A5[5]
           STW.D1T1      A4,*A8[5]


           LDW.D1T1      *A7[6],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[6],A3
           LDW.D1T1      *A8[6],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[6]
           STW.D1T2      B9,*A5[6]
           STW.D1T1      A4,*A8[6]


           LDW.D1T1      *A7[7],A4
           NOP 4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[7],A3
           LDW.D1T1      *A8[7],A4
           MPYSP.M1X     A3,B8,A3
           NOP           3
           MPYSP.M1X     A4,B7,A4
           NOP           3
           MPYSP.M1X     A3,B5,A3
           NOP           3
           MPYSP.M2X     B5,A4,B9
           NOP           3
           STW.D1T1      A3,*A9[7]
           STW.D1T2      B9,*A5[7]
           STW.D1T1      A4,*A8[7]

; swap B7 and B8 (enablers) for R processing
           MV.L2         B7,B9
           MV.L2         B8,B7
           MV.L2         B9,B8
; move B6 into B5 (volume R to volume(L)) for R processing
           MV.L2         B6,B5

; if B0 is not zero, then go to label and do another pass
; if B0 is zero, jump to return address that by convention is in B3
    [ B0]  B.S1          $C$L1
    [!B0]  B.S2          B3
; there will be a sea of NOPs afterwards, BNOP is not necessary
