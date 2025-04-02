*-----------------------------------------------------------
* Title      : 3x3 Matrix Multiplication
* Written by : Kevin Gutierrez
* Date       : 3/31/25
* Description: 3x3 matrix multiplication program
*-----------------------------------------------------------

    ORG    $1000
START:                  

    ;A1 -> Matrix A 
    LEA.L $00001000, A1
    
    ;A2 -> Matrix B
    LEA.L $00001020, A2
    
    ;A3 -> A * B result
    LEA.L $00001040, A3
    
    
    BRA POPULATE_A
    
    BRA POPULATE_B
    
    BRA CALCULATE_A_B_PRODUCT
    
    
    SIMHALT             

POPULATE_A:
    ; [row 1]
    MOVE.B #$2, (A1)
    MOVE.B #$1, 1(A1)
    MOVE.B #$3, 2(A1)
    
    ; [row 2]
    MOVE.B #$3, 3(A1)
    MOVE.B #$4, 4(A1)
    MOVE.B #$1, 5(A1)
    
    ; [row 3]
    MOVE.B #$5, 6(A1)
    MOVE.B #$2, 7(A1)
    MOVE.B #$3, 8(A1)

POPULATE_B:
    ; [row 1]
    MOVE.B #$1,  (A2)
    MOVE.B #$2, 1(A2)
    MOVE.B #$0, 2(A2)
    
    ; [row 2]
    MOVE.B #$4, 3(A2)
    MOVE.B #$1, 4(A2)
    MOVE.B #$2, 5(A2)
				   
    ; [row 3]      
    MOVE.B #$3, 6(A2)
    MOVE.B #$2, 7(A2)
    MOVE.B #$1, 8(A2)
   

CALCULATE_A_B_PRODUCT:
    ;D0 working data register
    ;D1 working data register
    ;D2 working sum register
    MOVE.B #0, D0
    MOVE.B #0, D1
    MOVE.B #0, D2
    
    ;D3 AB(k,0) value
    ;D4 AB(k,1) value
    ;D5 AB(k,2) value

    ;Reset D3,D4,D5 after each row has been evaluated    
    
    ;==================================== AB[0,0] ==============================================================================================================================
    
    ; Compute AB[0,0] = [(A0B0)+(A1B3)+(A2B6)]
    ;Evaluate A0B0, Add to sum                                                 ;BEGIN BLOCK                                ;O[0,0]
    MOVE.B (A1), D0 ; -> move A0 to D0
    EXT.W D0        ; -> extend D0 from byte to word size
    MOVE.B (A2), D1 ; -> move B0 to D1
    EXT.W D1        ; -> extend D1 from byte to word size

    MULS.W D0, D1  ; -> multiply D0 by D1, store in D1. D1 should now be -1
    ADD.L D1, D2 ; D2 now contains I0*K0                                        ;END BLOCK
                                                                                ;NOTE - All subsequent Evalute Ii*Kj blocks are repititions of the above block
    
    ;Evaluate A1B3, Add to sum
    MOVE.B 1(A1), D0 
    EXT.W D0        
    MOVE.B 3(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A2B6, Add to sum
    MOVE.B 2(A1), D0 
    EXT.W D0        
    MOVE.B 6(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[0,0] into D3
    MOVE.L D2, D3
    
    ; Reset sum register
    MOVE.L #0, D2
    
    ;==================================== AB[0,1] ==============================================================================================================================

    ; Compute AB[0,1] = [(A0B1)+(A1B4)+(A2B7)]
    ;Evaluate A0B1, Add to sum                                      
    MOVE.B (A1), D0 
    EXT.W D0        
    MOVE.B 1(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A1B4, Add to sum
    MOVE.B 1(A1), D0 
    EXT.W D0        
    MOVE.B 4(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A2B7, Add to sum
    MOVE.B 2(A1), D0 
    EXT.W D0        
    MOVE.B 7(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[0,1] into D4
    MOVE.L D2, D4
    
    ; Reset sum register
    MOVE.L #0, D2

    
    ;==================================== AB[0,2] ==============================================================================================================================
    
    ; Compute AB[0,1] = [(A0B2)+(A1B5)+(A2B8)]
    ;Evaluate A0B2, Add to sum                                      
    MOVE.B (A1), D0 
    EXT.W D0        
    MOVE.B 2(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A1B5, Add to sum
    MOVE.B 1(A1), D0 
    EXT.W D0        
    MOVE.B 5(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A2B8, Add to sum
    MOVE.B 2(A1), D0 
    EXT.W D0        
    MOVE.B 8(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[0,2] into D5
    MOVE.L D2, D5
    
    ; Reset sum register
    MOVE.L #0, D2
    
    ;==================================== LOAD FIRST ROW INTO RESULTANT MATRIX REGISTER ========================================================================================
    
    MOVE.L D3, (A3)+
    MOVE.L D4, (A3)+
    MOVE.L D5, (A3)+
    
    ;Reset element registers
    MOVE.L #0, D3
    MOVE.L #0, D4
    MOVE.L #0, D5
    
    ;==================================== AB[1,0] ==============================================================================================================================
    
    ; Compute AB[1,0] = [(A3B0)+(A4B3)+(A5B6)]
    ;Evaluate A3B0, Add to sum                                      
    MOVE.B 3(A1), D0 
    EXT.W D0        
    MOVE.B (A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A4B3, Add to sum
    MOVE.B 4(A1), D0 
    EXT.W D0        
    MOVE.B 3(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A5B6, Add to sum
    MOVE.B 5(A1), D0 
    EXT.W D0        
    MOVE.B 6(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[0,0] into D3
    MOVE.L D2, D3
    
    ; Reset sum register
    MOVE.L #0, D2
    
    ;==================================== AB[1,1] ==============================================================================================================================
    ; Compute AB[1,1] = [(A3B1)+(A4B4)+(A5B7)]
    
    ;Evaluate A3B1, Add to sum                                       
    MOVE.B 3(A1), D0 
    EXT.W D0        
    MOVE.B 1(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A4B4, Add to sum
    MOVE.B 4(A1), D0 
    EXT.W D0        
    MOVE.B 4(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A5B7, Add to sum
    MOVE.B 5(A1), D0 
    EXT.W D0        
    MOVE.B 7(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[1,1] into D4
    MOVE.L D2, D4
    
    ; Reset sum register
    MOVE.L #0, D2
    
;==================================== AB[1,2] ==============================================================================================================================
    ; Compute AB[1,2] = [(A3B2)+(A4B5)+(A5B8)]
    
    ;Evaluate A3B2, Add to sum                                       
    MOVE.B 3(A1), D0 
    EXT.W D0        
    MOVE.B 2(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A4B5, Add to sum
    MOVE.B 4(A1), D0 
    EXT.W D0        
    MOVE.B 5(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A5B8, Add to sum
    MOVE.B 5(A1), D0 
    EXT.W D0        
    MOVE.B 8(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[1,2] into D5
    MOVE.L D2, D5
    
    ; Reset sum register
    MOVE.L #0, D2
    
;==================================== LOAD SECOND ROW INTO RESULTANT MATRIX REGISTER ========================================================================================
    
    MOVE.L D3, (A3)+
    MOVE.L D4, (A3)+
    MOVE.L D5, (A3)+
    
    ;Reset element registers
    MOVE.L #0, D3
    MOVE.L #0, D4
    MOVE.L #0, D5
    
;==================================== AB[2,0] ==============================================================================================================================
    ; Compute AB[2,0] = [(A6B0)+(A7B3)+(A8B6)]
    
    ;Evaluate A6B0, Add to sum                                       
    MOVE.B 6(A1), D0 
    EXT.W D0        
    MOVE.B 0(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A7B3, Add to sum
    MOVE.B 7(A1), D0 
    EXT.W D0        
    MOVE.B 3(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A8B6, Add to sum
    MOVE.B 8(A1), D0 
    EXT.W D0        
    MOVE.B 6(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[2,0] into D3
    MOVE.L D2, D3
    
    ; Reset sum register
    MOVE.L #0, D2
    
;==================================== AB[2,1] ==============================================================================================================================
    ; Compute AB[2,1] = [(A6B1)+(A7B4)+(A8B7)]
    
    ;Evaluate A6B1, Add to sum                                       
    MOVE.B 6(A1), D0 
    EXT.W D0        
    MOVE.B 1(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A7B4, Add to sum
    MOVE.B 7(A1), D0 
    EXT.W D0        
    MOVE.B 4(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A8B7, Add to sum
    MOVE.B 8(A1), D0 
    EXT.W D0        
    MOVE.B 7(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place OB[2,1] into D4
    MOVE.L D2, D4
    
    ; Reset sum register
    MOVE.L #0, D2
    
;==================================== AB[2,2] ==============================================================================================================================
    ; Compute AB[2,2] = [(A6B2)+(A7B5)+(A8B8)]
    
    ;Evaluate A6B2, Add to sum                                       
    MOVE.B 6(A1), D0 
    EXT.W D0        
    MOVE.B 2(A2), D1 
    EXT.W D1       

    MULS.W D0, D1  
    ADD.L D1, D2 

    
    ;Evaluate A7B5, Add to sum
    MOVE.B 7(A1), D0 
    EXT.W D0        
    MOVE.B 5(A2), D1 
    EXT.W D1        

    MULS.W D0, D1  
    ADD.L D1, D2 
    
    ;Evaluate A8B8, Add to sum
    MOVE.B 8(A1), D0 
    EXT.W D0        
    MOVE.B 8(A2), D1 
    EXT.W D1        

    MULS.W D0, D1 
    ADD.L D1, D2 
    
    ;Finally, place AB[2,2] into D5
    MOVE.L D2, D5
    
    ; Reset sum register
    MOVE.L #0, D2
    
;==================================== LOAD THIRD ROW INTO RESULTANT MATRIX REGISTER ========================================================================================
    
    MOVE.L D3, (A3)+
    MOVE.L D4, (A3)+
    MOVE.L D5, (A3)+
    

    END    START        

     
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
