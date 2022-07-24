.audio
Fx_FLT_Div0:
; A4 stores first argument to function, it seems here it holds a structure
; load from structure using offsets
           LDW.D1T1      *A4[1],A3   ; "parameters" are loaded as offset from this address
           LDW.D1T2      *A4[12],B4  ; some source that is always loaded from, with increment
           LDW.D1T2      *A4[11],B5  ; some destination that is always written to
           LDW.D1T1      *A4[5],A6   ; address of Fx buffer, see how it is loaded to understand
           LDW.D1T2      *A4[4],B6   ; address of Dry buffer, see how it is loaded to understand

; using "parameters" address, load:
           LDW.D1T1      *A3[4],A7   ; probably knob level multiplier so that 100 on knob means 1.0 as float
           LDW.D1T1      *A3[5],A8   ; left knob value multiplier
           LDW.D1T1      *A3[6],A9   ; right knob value multiplier
 ||        LDW.D2T2      *B5[0],B5   ; prepare destination address, this logic is from inspiration
           LDW.D1T2      *A3[0],B7   ; effect on/off multiplier, 1.0 when on, 0.0 when off

           SUBAW.D1      A6,0x8,A6   ; decrement Fx buffer offset because each loop start with increment of it
 ||        MVK.L2        2,B0        ; prepare loop count
 ||        SUBAW.D2      B6,0x8,B6   ; decrement Dry buffer offset because each loop start with increment of it

; do calculations that need to be done once only
           MPYSP.M1      A8,A7,A8    ; adjusted left knob level
           MPYSP.M1      A9,A7,A9    ; adjusted right knob level

; 8 repeats for each channel buffer
; order of channels is left, right
$C$L1:
; # comment like this are housekeeping for iteration #
           LDW.D2T2      *B4[0],B8   ; this will be read 0,1,2 ... 7
           LDW.D1T1      *++A6[8],A4 ; # increment address # read Fx buffer
           LDW.D2T2      *++B6[8],B31; # increment address # read Dry buffer, value not used
           ADD.L2        B0,-1,B0    ; # decrement loop counter #
           NOP
           STW.D2T2      B8,*B5[0]   ; but always written to 0; this step is logic from inspiration

MULTIPLY_AND_WRITE .macro INDEX
           MPYSP.M1      A8,A4,A7    ; volume x fx
 ||        MPYSP.M2X     B7,A4,B9    ; on/off x fx
           NOP           3
           STW.D1T1      A7,*A6[INDEX] ; to Fx buffer
 ||        STW.D2T2      B9,*B6[INDEX] ; to Dry buffer
           .endm

           MULTIPLY_AND_WRITE 0

; and now repeat
; structure in inspiration is clearly a result of loop unroll
; but rolling it back required using registers as offset for other registers
; and that is way too complex for this excersise

FORINDEX .macro INDEX
           LDW.D1T1      *A6[INDEX],A4
 ||        LDW.D2T2      *B4[INDEX],B8
           NOP           4
           STW.D2T2      B8,*B5[0]

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
; set on/off to 1.0 for processing
 ||        MVK.L2        0,B7        ; set to 1.0 step 1
           SET.S2        B7,23,29,B7 ; set to 1.0 step 2

; if B0 is not zero, then go to label and do another pass
; if B0 is zero, jump to return address that by convention is in B3
    [ B0]  B.S1          $C$L1
    [!B0]  B.S2          B3
; there will be a sea of NOPs afterwards, BNOP is not necessary
