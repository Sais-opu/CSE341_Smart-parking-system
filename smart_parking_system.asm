.MODEL SMALL
.STACK 100H
.DATA
    ; --- MENU STRINGS ---
    MENU   DB "Choose Your Service: $"
    MENU1  DB "[1] Display Empty Parking Slots$"
    MENU2  DB "[2] Vehicle Entry$"
    MENU3  DB "[3] Vehicle Exit & Billing$"
    MENU4  DB "[4] Search by Vehicle Number$"
    MENU5  DB "[5] Daily Report Generation$"
    MENU6  DB "[6] VIP Reserved Entry$"
    MENU0  DB "[0] Exit$"
    
    ; --- SEPARATORS ---
    LINE    DB "============================$"
    EX      DB "You Have Exited From the System$"
    
    ; --- DATA ARRAYS ---
    BIKES     DB 10 DUP(0)
    CARS      DB 15 DUP(0)
    BUSES     DB 5 DUP(0)
    VIP_SLOTS DB 5 DUP(0)
    VIP_PINS  DW 1234, 5555, 9999
    
    ; --- VARIABLES ---
    SEARCH_ID   DB ?
    SEARCH_ZONE DB ?
    HOURS_VAR   DB ? 
    TOTAL_VEH   DW 0
    TOTAL_EARN  DW 0
    
    ; --- TITLES ---
    FEATURE1 DB "Check Empty Parking Slots$"
    FEATURE2 DB "Vehicle Entry System$"
    FEATURE3 DB "Vehicle Exit & Billing System$"
    FEATURE4 DB "Search by Your Vehicle Number$"
    FEATURE5 DB "Daily Report Generation$"
    FEATURE6 DB "VIP Reserved Entry System$"
    
    ; --- PROMPTS ---
    ZONE_ENTRY_MSG DB "Select Zone -> [1] Bike [2] Car [3] Bus: $"
    ZONE_ALL_MSG   DB "Select Zone -> [1] Bike [2] Car [3] Bus [4] VIP: $"
    
    INPUT_MSG   DB "Enter Vehicle ID (e.g. C1, DA, V5): $"
    SLOT_IN     DB "Enter Slot Number (Type & Press Enter): $"
    HOURS_IN    DB "Enter Hours Parked: $"
    PIN_PROMPT  DB "Enter VIP PIN: $"
    
    ; --- OUTPUTS ---
    MSG_FULL       DB "No Parking Slots Available!$"
    MSG_OK         DB "Entry Successful! Park in Slot: $"
    MSG_ERR        DB "Error: Invalid Input!$"
    MSG_SLOT_EMPTY DB "Error: Slot is Already Empty!$" ; NEW ERROR MSG
    MSG_BILL       DB "Total Bill: $"
    MSG_TAKA       DB " Taka$"
    
    EMPTY_MSG  DB "Empty Slots: $"
    NO_EMPTY   DB "None$"
    
    NOT_FOUND_MSG DB "No Vehicle Found$"
    FOUND_MSG     DB " Found in Slot: $"
    VEHICLE_MSG   DB "Vehicle $"
    
    REP_VEH   DB "Total Vehicles Parked Today: $"
    REP_EARN  DB "Total Earnings Today: $"
    REP_EMPTY DB "Total Remaining Empty Slots: $"
    
    B_TXT DB " [Bike Zone]$"
    C_TXT DB " [Car Zone]$"
    D_TXT DB " [Bus Zone]$" 
    V_TXT DB " [VIP Zone]$"
    
    NEWLINE DB 0AH, 0DH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MENU_LOOP:
    CALL LINES_PROC
    LEA DX, MENU1
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU2
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU3
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU4
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU5
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU6
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU0
    MOV AH, 9
    INT 21H
    
    CALL PRINT_NL
    
    LEA DX, MENU
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    
    CMP AL, 0
    JE EXIT_PROG
    
    CMP AL, 1
    JE DO_FEAT1

    CMP AL, 2
    JE DO_FEAT2
    
    CMP AL, 3
    JE DO_FEAT3
    
    CMP AL, 4
    JE DO_FEAT4
    
    CMP AL, 5
    JE DO_FEAT5
    
    CMP AL, 6
    JE DO_FEAT6
    
    JMP MENU_LOOP

DO_FEAT1:
    CALL LINES_PROC
    
    LEA DX, FEATURE1
    MOV AH, 9
    INT 21H
    
    CALL LINES_PROC
    
    CALL DISPLAY_PROC
    
    JMP MENU_LOOP
    
DO_FEAT2:
    CALL LINES_PROC
    
    LEA DX, FEATURE2
    MOV AH, 9
    INT 21H
    
    CALL LINES_PROC
    
    CALL ENTRY_PROC
    
    JMP MENU_LOOP

DO_FEAT3:
    CALL LINES_PROC
    LEA DX, FEATURE3
    MOV AH, 9
    INT 21H
    CALL LINES_PROC
    CALL EXIT_PROC
    JMP MENU_LOOP

DO_FEAT4:
    CALL LINES_PROC
    CALL SEARCH_PROC
    JMP MENU_LOOP

DO_FEAT5:
    CALL LINES_PROC
    CALL REPORT_PROC
    JMP MENU_LOOP

DO_FEAT6:
    CALL LINES_PROC
    CALL VIP_PROC
    JMP MENU_LOOP

EXIT_PROG:
    CALL LINES_PROC
    LEA DX, EX
    MOV AH, 9
    INT 21H 
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

LINES_PROC PROC
    CALL PRINT_NL
    LEA DX, LINE
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    RET
LINES_PROC ENDP

PRINT_NL PROC
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    RET
PRINT_NL ENDP

;-----------------------------------------
;Feature 1
;-----------------------------------------

DISPLAY_PROC PROC
    LEA DX, ZONE_ALL_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    
    MOV BL, AL
    SUB BL, 30H
          
    CALL PRINT_NL
    
    CMP BL, 1
    JE SHOW_BIKE
    
    CMP BL, 2
    JE SHOW_CAR
    
    CMP BL, 3
    JE SHOW_BUS
    
    CMP BL, 4
    JE SHOW_VIP
    JMP INVALID_INPUT
SHOW_BIKE:
    MOV SI, OFFSET BIKES
    MOV CX, 10
    LEA DX, B_TXT
    JMP PRINT_ZONE_INFO
SHOW_CAR:
    MOV SI, OFFSET CARS
    MOV CX, 15
    LEA DX, C_TXT
    JMP PRINT_ZONE_INFO
SHOW_BUS:
    MOV SI, OFFSET BUSES
    MOV CX, 5
    LEA DX, D_TXT
    JMP PRINT_ZONE_INFO
SHOW_VIP:
    MOV SI, OFFSET VIP_SLOTS
    MOV CX, 5
    LEA DX, V_TXT
PRINT_ZONE_INFO:
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    LEA DX, EMPTY_MSG
    MOV AH, 9
    INT 21H
    MOV DL, 1
    MOV BL, 0
CHECK_SLOTS:
    MOV AL, [SI]
    CMP AL, 0
    JNE NEXT_SLOT
    INC BL
    MOV AL, DL
    MOV AH, 0
    PUSH DX
    CALL PRINT_NUM
    POP DX
    PUSH DX
    MOV DL, '|'
    MOV AH, 2
    INT 21H
    POP DX
NEXT_SLOT:
    INC SI
    INC DL
    LOOP CHECK_SLOTS
    CMP BL, 0
    JNE FINISH_DISP
    LEA DX, NO_EMPTY
    MOV AH, 9
    INT 21H
FINISH_DISP:
    RET
INVALID_INPUT:
    LEA DX, MSG_ERR
    MOV AH, 9
    INT 21H
    RET
DISPLAY_PROC ENDP

;-----------------------------------------
;Feature 2
;-----------------------------------------

ENTRY_PROC PROC
    LEA DX, ZONE_ENTRY_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    CALL PRINT_NL
    CMP BL, '1'
    JE ENT_BIKE
    CMP BL, '2'
    JE ENT_CAR
    CMP BL, '3'
    JE ENT_BUS
    JMP INVALID_INPUT
ENT_BIKE:
    MOV SI, OFFSET BIKES
    MOV CX, 10
    JMP GET_ID_AND_STORE
ENT_CAR:
    MOV SI, OFFSET CARS
    MOV CX, 15
    JMP GET_ID_AND_STORE
ENT_BUS:
    MOV SI, OFFSET BUSES
    MOV CX, 5
GET_ID_AND_STORE:
    PUSH CX
    PUSH SI
    LEA DX, INPUT_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BH, AL
    POP SI
    POP CX
    MOV DL, 1
FIND_FREE:
    CMP BYTE PTR [SI], 0
    JE FOUND_FREE
    INC SI
    INC DL
    LOOP FIND_FREE
    CALL PRINT_NL
    LEA DX, MSG_FULL
    MOV AH, 9
    INT 21H
    RET
FOUND_FREE:
    MOV [SI], BH
    INC TOTAL_VEH
    MOV AL, DL
    MOV AH, 0
    PUSH AX
    CALL PRINT_NL
    LEA DX, MSG_OK
    MOV AH, 9
    INT 21H
    POP AX
    CALL PRINT_NUM
    RET
ENTRY_PROC ENDP

;-----------------------------------------
;Feature 3
;-----------------------------------------

EXIT_PROC PROC
    LEA DX, ZONE_ALL_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    CALL PRINT_NL
    CMP BL, '1'
    JE EXIT_BIKE
    CMP BL, '2'
    JE EXIT_CAR
    CMP BL, '3'
    JE EXIT_BUS
    CMP BL, '4'
    JE EXIT_VIP
    JMP INVALID_INPUT
EXIT_BIKE:
    MOV SI, OFFSET BIKES
    JMP ASK_SLOT
EXIT_CAR:
    MOV SI, OFFSET CARS
    JMP ASK_SLOT
EXIT_BUS:
    MOV SI, OFFSET BUSES
    JMP ASK_SLOT
EXIT_VIP:
    MOV SI, OFFSET VIP_SLOTS
ASK_SLOT:
    LEA DX, SLOT_IN
    MOV AH, 9
    INT 21H
    MOV BX, 0
INPUT_SLOT_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, 0DH 
    JE INPUT_DONE
    SUB AL, 30H
    MOV AH, 0
    PUSH AX
    MOV AX, BX
    MOV CX, 10
    MUL CX
    MOV BX, AX
    POP AX
    ADD BX, AX
    JMP INPUT_SLOT_LOOP
INPUT_DONE:
    SUB BX, 1 
    ADD SI, BX
    
    ; --- NEW CHECK START ---
    CMP BYTE PTR [SI], 0
    JE EMPTY_ERROR
    ; --- NEW CHECK END ---
    
    MOV BYTE PTR [SI], 0
    CALL PRINT_NL
    LEA DX, HOURS_IN
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, 30H 
    MOV HOURS_VAR, AL 
    MOV AH, 0 
    MOV BX, 5 
    MUL BX 
    CMP HOURS_VAR, 5
    JL PRINT_BILL 
    SUB AX, 10 
PRINT_BILL:
    ADD TOTAL_EARN, AX
    PUSH AX 
    CALL PRINT_NL
    LEA DX, MSG_BILL
    MOV AH, 9
    INT 21H
    POP AX 
    CALL PRINT_NUM
    LEA DX, MSG_TAKA
    MOV AH, 9
    INT 21H
    RET
EMPTY_ERROR:
    CALL PRINT_NL
    LEA DX, MSG_SLOT_EMPTY
    MOV AH, 9
    INT 21H
    RET
EXIT_PROC ENDP

;-----------------------------------------
;Feature 4
;-----------------------------------------

SEARCH_PROC PROC
    LEA DX, FEATURE4
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    LEA DX, INPUT_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV SEARCH_ZONE, AL
    MOV AH, 1
    INT 21H
    MOV SEARCH_ID, AL
    CMP SEARCH_ZONE, 'B'
    JE SRC_BIKE
    CMP SEARCH_ZONE, 'C'
    JE SRC_CAR
    CMP SEARCH_ZONE, 'D'
    JE SRC_BUS
    CMP SEARCH_ZONE, 'V'
    JE SRC_VIP
    JMP NOT_FOUND
SRC_BIKE:
    MOV SI, OFFSET BIKES
    MOV CX, 10
    LEA DX, B_TXT
    JMP PERFORM_SEARCH
SRC_CAR:
    MOV SI, OFFSET CARS
    MOV CX, 15
    LEA DX, C_TXT
    JMP PERFORM_SEARCH
SRC_BUS:
    MOV SI, OFFSET BUSES
    MOV CX, 5
    LEA DX, D_TXT
    JMP PERFORM_SEARCH
SRC_VIP:
    MOV SI, OFFSET VIP_SLOTS
    MOV CX, 5
    LEA DX, V_TXT
PERFORM_SEARCH:
    PUSH DX
    MOV DL, 1
    MOV BH, SEARCH_ID
SEARCH_LOOP:
    MOV AL, [SI]
    CMP AL, BH
    JE FOUND_IT
    INC SI
    INC DL
    LOOP SEARCH_LOOP
    POP DX
    JMP NOT_FOUND
FOUND_IT:
    POP BX
    PUSH DX 
    CALL PRINT_NL
    LEA DX, VEHICLE_MSG
    MOV AH, 9
    INT 21H
    MOV DL, SEARCH_ZONE
    MOV AH, 2
    INT 21H
    MOV DL, SEARCH_ID
    MOV AH, 2
    INT 21H
    LEA DX, FOUND_MSG
    MOV AH, 9
    INT 21H
    POP AX
    MOV AH, 0
    CALL PRINT_NUM
    MOV DX, BX
    MOV AH, 9
    INT 21H
    RET
NOT_FOUND:
    CALL PRINT_NL
    LEA DX, NOT_FOUND_MSG
    MOV AH, 9
    INT 21H
    RET
SEARCH_PROC ENDP

PRINT_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 0
    MOV BX, 10
DP: 
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DP
DO: 
    POP DX
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    LOOP DO
    POP DX
    POP CX
    POP BX
    RET
PRINT_NUM ENDP

;-----------------------------------------
;Feature 5
;-----------------------------------------

REPORT_PROC PROC
    LEA DX, FEATURE5
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    LEA DX, REP_VEH
    MOV AH, 9
    INT 21H
    MOV AX, TOTAL_VEH
    CALL PRINT_NUM
    CALL PRINT_NL
    LEA DX, REP_EARN
    MOV AH, 9
    INT 21H
    MOV AX, TOTAL_EARN
    CALL PRINT_NUM
    LEA DX, MSG_TAKA
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    MOV BX, 0
    MOV SI, OFFSET BIKES
    MOV CX, 10
C1: CMP BYTE PTR [SI], 0
    JNE S1
    INC BX
S1: INC SI
    LOOP C1
    MOV SI, OFFSET CARS
    MOV CX, 15
C2: CMP BYTE PTR [SI], 0
    JNE S2
    INC BX
S2: INC SI
    LOOP C2
    MOV SI, OFFSET BUSES
    MOV CX, 5
C3: CMP BYTE PTR [SI], 0
    JNE S3
    INC BX
S3: INC SI
    LOOP C3
    MOV SI, OFFSET VIP_SLOTS
    MOV CX, 5
C4: CMP BYTE PTR [SI], 0
    JNE S4
    INC BX
S4: INC SI
    LOOP C4
    LEA DX, REP_EMPTY
    MOV AH, 9
    INT 21H
    MOV AX, BX
    CALL PRINT_NUM
    RET
REPORT_PROC ENDP

;-----------------------------------------
;Feature 6
;-----------------------------------------

VIP_PROC PROC
    LEA DX, FEATURE6
    MOV AH, 9
    INT 21H
    CALL PRINT_NL
    LEA DX, PIN_PROMPT
    MOV AH, 9
    INT 21H
    MOV BX, 0
P_IN:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE P_DONE
    SUB AL, 30H
    MOV AH, 0
    PUSH AX
    MOV AX, 10
    MUL BX
    POP BX
    ADD BX, AX
    JMP P_IN
P_DONE:
    MOV SI, OFFSET VIP_PINS
    MOV CX, 3
V_CHK:
    CMP BX, [SI]
    JE V_OK
    ADD SI, 2
    LOOP V_CHK
    LEA DX, MSG_ERR
    MOV AH, 9
    INT 21H
    RET
V_OK:
    CALL PRINT_NL
    LEA DX, INPUT_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BH, AL
    MOV SI, OFFSET VIP_SLOTS
    MOV CX, 5
    MOV DL, 1
V_FREE:
    CMP BYTE PTR [SI], 0
    JE V_FOUND
    INC SI
    INC DL
    LOOP V_FREE
    LEA DX, MSG_FULL
    MOV AH, 9
    INT 21H
    RET
V_FOUND:
    MOV [SI], BH
    INC TOTAL_VEH
    MOV AL, DL
    MOV AH, 0
    PUSH AX
    CALL PRINT_NL
    LEA DX, MSG_OK
    MOV AH, 9
    INT 21H
    POP AX
    CALL PRINT_NUM
    RET
VIP_PROC ENDP

END MAIN



