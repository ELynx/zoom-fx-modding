.audio
Fx_FLT_RTFM:
; A4 stores first argument to function, it seems here it holds a structure
; load from structure using offsets
           LDW.D1T1      *A4[1],A3   ; "parameters" are loaded as offset from this address
           LDW.D1T2      *A4[12],B4  ; some source that is always loaded from, with increment
           LDW.D1T2      *A4[11],B5  ; some destination that is always written to
           LDW.D1T1      *A4[6],A5   ; address of Output buffer, see how it is loaded to understand
           LDW.D1T1      *A4[5],A6   ; address of Fx buffer, see how it is loaded to understand
           LDW.D1T2      *A4[4],B6   ; address of Dry buffer, see how it is loaded to understand

; using "parameters" address, load:
           LDW.D1T1      *A3[4],A7   ; probably knob level multiplier so that 100 on knob means 1.0 as float
           LDW.D1T1      *A3[5],A8   ; left knob value multiplier
           LDW.D1T1      *A3[6],A30  ; right knob value multiplier
           LDW.D1T1      *A3[0],A9   ; effect on/off multiplier, 1.0 when on, 0.0 when off

           SUBAW.D1      A5,0x8,A5   ; decrement Output buffer offset because each loop start with increment of it
 ||        MVK.L2        0,B7        ; set to 1.0 step 1
 ||        LDW.D2T2      *B5[0],B5   ; prepare destination address, this logic is from inspiration
           SUBAW.D1      A6,0x8,A6   ; decrement Fx buffer offset because each loop start with increment of it
 ||        SET.S2        B7,23,29,B7 ; set to 1.0 step 2
 ||        MVK.L2        2,B0        ; prepare loop count

; do calculations that need to be done once only
           MPYSP.M1      A8,A7,A8    ; adjusted left knob level
           MPYSP.M1      A30,A7,A30  ; adjusted right knob level
           SUBSP.L2X     B7,A9,B7    ; make into 1.0 - effect on/off, 0.0 when on, 1.0 when off

; 8 repeats for each channel buffer
; order of channels is left, right
$C$L1:
; # comment like this are housekeeping for iteration #
           LDW.D2T2      *B4[0],B8   ; this will be read 0,1,2 ... 7
; vvv instruction sandwitch instead of NOP 4
           MPYSP.M1      A8,A9,A3    ; # volume x [enabled / disabled] #
           LDW.D1T1      *++A5[8],A31; # increment address # read Output buffer, value not used
           MPYSP.M2X     B7,A8,B9    ; # volume x [disabled / enabled] #
           ADD.L2        B0,-1,B0    ; # decrement loop counter #
; ^^^
           STW.D2T2      B8,*B5[0]   ; but always written to 0; this step is logic from inspiration

           LDW.D1T1      *++A6[8],A4 ; # increment address # read Fx buffer
 ||        LDW.D2T2      *B6[0],B8   ; read Dry buffer
           NOP           4

MULTIPLY_AND_WRITE .macro INDEX
           MPYSP.M1      A4,A3,A4    ; fx  x volume x [enable / disable]
 ||        MPYSP.M2      B8,B9,B8    ; dry x volume x [disable / enable]
           NOP           3
           STW.D1T1      A4,*A5[INDEX]   ; to Output buffer
 ||        STW.D2T2      B8,*B6[INDEX]   ; to Dry buffer
           STW.D1T2      B8,*A6[INDEX]   ; to Fx buffer
.endm

           MULTIPLY_AND_WRITE 0

; and now repeat
; structure in inspiration is clearly a result of loop unroll
; but rolling it back required using registers as offset for other registers
; and that is way too complex for this excersise

FORINDEX .macro INDEX
           LDW.D2T2      *B4[INDEX],B8
           NOP           4
           STW.D2T2      B8,*B5[0]

           LDW.D1T1      *A6[INDEX],A4
 ||        LDW.D2T2      *B6[INDEX],B8
           NOP           4
           MULTIPLY_AND_WRITE INDEX
.endm

           FORINDEX 1
           FORINDEX 2
           FORINDEX 3
           FORINDEX 4
           FORINDEX 5
           FORINDEX 6
           FORINDEX 7

; at the end of iteration

; volume R to volume for R processing
           MV.S1         A30,A8
; swap K and K' for R processing
 ||        MV.L1         A9,A4
 ||        MV.L2         B7,B8
           MV.L2X        A4,B7
 ||        MV.L1X        B8,A9

; if B0 is not zero, then go to label and do another pass
; if B0 is zero, jump to return address that by convention is in B3
    [ B0]  B.S1          $C$L1
    [!B0]  B.S2          B3
; there will be a sea of NOPs afterwards, BNOP is not necessary
