.audio
Fx_FLT_RainSel:
; A4 stores first argument to function, it seems here it holds a structure
; load from structure using offsets
           LDW.D1T2      *A4[1],B4   ; "parameters" are loaded as offset from this address
           LDW.D1T1      *A4[12],A7  ; some source that is always loaded from, with increment
           LDW.D1T1      *A4[11],A6  ; some destination that is always written to
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
           SUBAW.D1      A5,0x8,A5   ; prepare read "FxIn" offset, this logic is from inspiration
 ||        SET.S2        B7,23,29,B7 ; set B7 to 1.0 step 2
 ||        MVK.L2        2,B0        ; prepare loop count

; do calculations that need to be done once only
           MPYSP.M2      B5,B9,B5    ; adjusted left knob level
           NOP           3
           MPYSP.M2      B6,B9,B6    ; adjusted right knob level

; iterate over left and right channels (buffers)
; order is left, right
$C$L1:
; instead of nop 3 for MPYSP
           LDW.D1T1      *A7[0],A4   ; this will be read 0,1,2 ... 7
           NOP           4
           STW.D1T1      A4,*A6[0]   ; but always written to 0; this step is logic from inspiration

; for this iteration, calculate fx and dry coefficients, and put them to register A for fast access
           MPYSP.M2      B5,B7,B9 ; (fx level x fx state)
           ADD.L2        B0,-1,B0 ; decrement loop counter, while we have a moment
           NOP           2
           MV.L1X        B9,A24
           MPYSP.M2      B6,B8,B9 ; (dry level x dry state)
           NOP           3
           MV.L1X        B9,A26

           LDW.D1T1      *++A5[8],A3 ; this step is logic from inspiration, read FxIn
 ||        MV.L2         B7,B9       ; parallel three glasses swap fx and dry states: fx -> storage
           LDW.D1T1      *A8[0],A4   ; read GuitarIn
 ||        MV.L2         B8,B7       ; dry -> fx
           MV.L2         B9,B8       ; storage -> dry
           NOP           2
           MPYSP.M1      A3,A24,A3   ; fx in x fx coefficient
           NOP           3
           MPYSP.M1      A4,A26,A4   ; dry level x dry coefficient
           NOP           3
           ADDSP.L1      A3,A4,A3    ; sum fx and dry into tmp
           NOP           3
           STW.D1T1      A3,*A5[0]   ; write tmp where FxIn was taken from


; and now repeat above for index 1
; structure in inspiration is clearly a result of loop unroll
; but rolling it back required using registers as offset for other registers
; and that is way too complex for this excersise
           LDW.D1T1      *A7[1],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[1],A3
           LDW.D1T1      *A8[1],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[1]


           LDW.D1T1      *A7[2],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[2],A3
           LDW.D1T1      *A8[2],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[2]


           LDW.D1T1      *A7[3],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[3],A3
           LDW.D1T1      *A8[3],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[3]


           LDW.D1T1      *A7[4],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[4],A3
           LDW.D1T1      *A8[4],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[4]


           LDW.D1T1      *A7[5],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[5],A3
           LDW.D1T1      *A8[5],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[5]


           LDW.D1T1      *A7[6],A4
           NOP           4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[6],A3
           LDW.D1T1      *A8[6],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[6]


           LDW.D1T1      *A7[7],A4
           NOP 4
           STW.D1T1      A4,*A6[0]

           LDW.D1T1      *A5[7],A3
           LDW.D1T1      *A8[7],A4
           NOP           3
           MPYSP.M1      A3,A24,A3
           NOP           3
           MPYSP.M1      A4,A26,A4
           NOP           3
           ADDSP.L1      A3,A4,A3
           NOP           3
           STW.D1T1      A3,*A5[7]

; if B0 is not zero, then go to label and do another pass
; if B0 is zero, jump to return address that by convention is in B3
    [ B0]  B.S1          $C$L1
    [!B0]  B.S2          B3
; there will be a sea of NOPs afterwards, BNOP is not necessary
