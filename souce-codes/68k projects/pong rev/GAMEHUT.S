;----------------------------------------------------------
;		pong revolution ver0.4(13:10 07/07/2020)
;		BY Extra Joe
;----------------------------------------------------------
		INCLUDE	SYSTEM.S		;INCLUDES LOTS OF SYSTEM CODE TO MAKE ALL THIS POSSIBLE (hopefully replase later) By Jon Burton (GameHut)

;----------------------------------------------------------
;		VRAM MEMORY MAP IN HEXADECIMAL
;----------------------------------------------------------
;		$0000-$0020			BLANK CHARACTER
;		$0020-$8000			CHARACTERS FOR PLAYFIELDS AND SPRITES
;		$C000-$D000			CHARACTER MAP FOR PLAYFIELD 1 (4096 BYTES)
;		$E000-$F000			CHARACTER MAP FOR PLAYFIELD 2 (4096 BYTES)
;		$F800				SPRITE TABLE (960 BYTES)

;----------------------------------------------------------
;		USER VARIABLES
;----------------------------------------------------------
		RSSET	USERRAM
player1X:		RS.W	1			;player1'S X POSITION
player1Y:		RS.W	1			;player1'S Y POSITION
BALLX:		RS.W	1			;BALL'S X POSITION
BALLY:		RS.W	1			;BALL'S Y POSITION
BALLD:		RS.W	1			;BALL'S DIRECTION
player2X:	RS.W	1			;player2'S X POSITION
player2Y:	RS.W	1			;player2'S Y POSITION
TEMPSCREEN:	RS.B	4096			;RAM TO BUILD TEMPORARY SCREEN MAP
ENDVARS:	RS.B	0

;----------------------------------------------------------
;		INITIALISE USER STUFF
;		- THIS IS WHERE YOU SET UP STUFF BEFORE YOU BEGIN
;----------------------------------------------------------
USERINIT:	
		DMADUMP	BALLGFX,1*32,$1100		;DUMP 1 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1100 (MAP GRAPHICS)
		DMADUMP	SPRITEGFX,3*32,$1000	;DUMP 3 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1000 (SPRITE GRAPHICS)
;----------------------------------------------------------
;		Palettes
;----------------------------------------------------------
		LEA.L	PALETTE1,A0		;DOWNLOAD A PALETTE FOR THE MAP TO USE
		BSR	SETPAL1			;OVERRIGHT FIRST PALETTE

		LEA.L	PALETTE2,A0		;DOWNLOAD A PALETTE FOR THE SPRITES TO USE
		BSR	SETPAL2			;OVERRIGHT SECOND PALETTE	

		JSR	DUMPCOLS		;COPY ALL PALETTES TO CRAM (COLOUR RAM)

		MOVE.W	#$80+160-130,player1X	;player1'S X START POSITION
		MOVE.W	#$80+112-13,player1Y	;player1'S Y START POSITION
		MOVE.W	#$80+160+130,player2X	;player1'S X START POSITION
		MOVE.W	#$80+112-13,player2Y	;player1'S Y START POSITION
		MOVE.W	#$80+80+80,BALLX	;player1'S X START POSITION
		MOVE.W	#$80+112-13,BALLY	;player1'S Y START POSITION
		MOVE.W 	#1,BALLD			;puts 01 in to BALLD
		RTS

;------------------------------
;	MAIN GAME LOOP
;------------------------------
MAIN:		WAITVBI					;WAITS FOR THE START OF THE NEXT FRAME
;ADD SPRITES
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		MOVE.W	#1,D7
;player 1
		MOVE.W	player1Y,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X3,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL2+$1000/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	player1X,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		ADDQ.W	#1,D7
;player 2							
		MOVE.W	player2Y,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X3,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL2+$1000/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	player2X,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER

							;A1=POINTER TO NEXT SPRITE ENTRY
							;D7=NEXT SPRITE NUMBER

;ball							
		MOVE.W	BALLY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X1,D0			;SIZE OF CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL2+$1100/32,D0		;PALETTE NUMBER + VRAM LOCATION/32 in to D0
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE 
		MOVE.W	BALLX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER

							;A1=POINTER TO NEXT SPRITE ENTRY
							;D7=NEXT SPRITE NUMBER
;END
		MOVE.L	#$10000,(A1)+			;TERMINATE SPRITE LIST
		MOVE.L	#1,(A1)+			;	"  "
		
;hit detection
		MOVE.W	BALLX,D3			;put BALLX in to D3
		MOVE.W	BALLY,D4			;put BALLY in to D4
		MOVE.W	BALLD,D5			;put BALLD in to D5
		move.w 	player2X,d1			;put player2X in to D1	
		move.w 	player1X,d0			;put player1X in to d0
		
		cmp.w	#1,d5				;if d5 (BALLD) = 0
		beq		@right				;goto right
		
		add.w	#8,D0				;adds 8 to D0 (player1X)
		cmp.w 	D0,D3				;if d3 = d0
		beq		@dumb1				;goto dumb1
		jmp		@BALL_CODE			;goto BALL_CODE

@right:
		sub.w	#8,D1				;adds 8 to D1 (player2x)
		cmp.w 	D1,D3				;If D1(player2X) = D3(BALLX)
		beq		@up					;goto up
		jmp		@BALL_CODE			;goto BALL_CODE
		
@up:
		move	player1Y,D1			;put player1Y in to D1	
		sub.w	#8,D1				;sub 8 to D1 (player2x)
		cmp.w	D1,BALLY			;If D1 = BALLY 
		beq		
		

@dumb1:
		MOVE.W	#1,BALLD     		;put 0 in BALLD (changes direction) 
		jmp		@BALL_CODE			;goto BALL_CODE


@dumb2:
		MOVE.W	#0,BALLD     		;put 1 in BALLD

@BALL_CODE:
		cmp.w	#0,	d5				;if d5 = 0
		beq		@skip				;goto skip
		add.w	#2, BALLX			;add 2 to ballX
@skip:
		sub.w	#1, BALLX			;sub 1 to ballX
	
;@miss:
	
	
 ;---soon to be top and bottom barrier---		
;		move.w	,d0
;		move.w	,d1
;		cmp.w	

;MOVE player1
		BTST	#J_DOWN,JOYPAD0
		BNE.S	@MOVE1
		ADD.W	#1,player1Y	
@MOVE1:
		BTST	#J_UP,JOYPAD0
		BNE.S	@MOVE2
		SUB.W	#1,player1Y	
;MOVE player2
@MOVE2:
		BTST	#J_BUT_A,JOYPAD0
		BNE.S	@MOVE3
		SUB.W	#1,player2Y	
		
@MOVE3:
		BTST	#J_BUT_B,JOYPAD0
		BNE.S	@MOVE4
		ADD.W	#1,player2Y
;ball move		
@MOVE4:
		BTST	#J_LEFT,JOYPAD0
		BNE.S	@MOVE5
		MOVE.W	#1,BALLD
		
@MOVE5:
		BTST	#J_RIGHT,JOYPAD0
		BNE.S	@NORING
		MOVE.W	#0,BALLD

@NORING:

		BRA	MAIN				;LOOP BACK TO WAIT FOR NEXT FRAME
		
;----------------------------------------------------------
;		USER VBI ROUTINES
;		- PUT TIME CRITICAL CODE THAT MUST CALLED DURING THE VERTICAL BLANK HERE
;----------------------------------------------------------
USERVBI:	LEA.L	VDP_DATA,A1
			LEA.L	VDP_CONTROL,A2
;SET HORIZONTAL OFFSETS
;		MOVE.L	#$7C000003,(A2)
;		MOVE.L	PLAYX,(A1)		;THIS TELLS THE VDP (VISUAL DISPLAY PROCESSOR) WHAT X POSITION THE PLAYFIELDS SHOULD BE AT

;SET VERTICAL OFFSETS
;		MOVE.L	#$40000010,(A2)		;THIS TELLS THE VDP WHAT Y POSITION THE PLAYFIELDS SHOULD BE AT
;		MOVE.L	PLAYY,(A1)

;COPY SPRITE TABLE TO VRAM
		JSR	SPRITEDUMP
;READ JOYPAD
		BSR	READJOY			;READ THE JOYPAD

		RTS

;----------------------------------------------------------
;		SPRITE GRAPHICS
;		2 X 4 CHARACTERS ARRANGED AS FOLLOWS -
;
;		1 3
;		2 4
;		
;		
;----------------------------------------------------------
SPRITEGFX:	
		DC.B	$04,$44,$44,$40		;2
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
				
		DC.B	$44,$44,$44,$44		;2
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		
		DC.B	$44,$44,$44,$44		;2
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$04,$44,$44,$40
;----------------------------------------------------------
BALLGFX:
		DC.B	$04,$44,$44,$40		;2
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$04,$44,$44,$40
;----------------------------------------------------------
;		USER PALETTES
;----------------------------------------------------------
PALETTE1:	
		DC.W	$0000,$0044,$0066,$0088
		DC.W	$00AA,$00EE,$0888,$FF00
		DC.W	$0EEE,$0CCC,$0AAA,$0888
		DC.W	$0666,$0444,$0222,$0000

PALETTE2:	
		DC.W	$0000,$0000,$0F80,$08CE	
		DC.W	$0EEE,$00E0,$000E,$00EE
		DC.W	$0088,$0044,$0066,$0AAA
		DC.W	$0666,$0444,$0222,$0888

