;----------------------------------------------------------
;		pong revolution ver0.5(13:10 07/07/2020)
;		BY Extra Joe
;----------------------------------------------------------
		INCLUDE	SYSTEM.S		;INCLUDES LOTS OF SYSTEM code TO MAKE ALL THIS POSSIBLE (hopefully replase later) By Jon Burton (GameHut)

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
player1X:	RS.W	1				;player1'S X position
player1Y:	RS.W	1				;player1'S Y position
player2X:	RS.W	1				;player2'S X position
player2Y:	RS.W	1				;player2'S Y position
player1S:	RS.W	1				;Player1'S score 
player2S:	RS.W	1				;player2'S score
BallX:		RS.W	1				;Ball'S X position
BallY:		RS.W	1				;Ball'S Y position
BallD:		RS.W	1				;Ball'S direction
BallYM:		RS.W	1				;Ball'S Y movement (Y speed)
BallXM:		RS.W	1				;Ball'S X movement (X speed)	
TBar:		RS.W	1				;top barrier
BBar:		RS.W	1				;bottom barrier
TEMPSCREEN:	RS.B	4096				;RAM TO BUILD TEMPORARY SCREEN MAP
ENDVARS:	RS.B	0

;----------------------------------------------------------
;		INITIALISE USER STUFF
;		- THIS IS WHERE YOU SET UP STUFF BEFORE YOU BEGIN
;----------------------------------------------------------
USERINIT:	
		DMADUMP	BallGFX,1*32,$1100		;DUMP 1 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1100 (MAP GRAPHICS)
		DMADUMP	SPRITEGFX,3*32,$1000		;DUMP 3 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1000 (SPRITE GRAPHICS)
;----------------------------------------------------------
;		Palettes
;----------------------------------------------------------
		LEA.L	PALETTE1,A0			;DOWNLOAD A PALETTE FOR THE MAP TO USE
		BSR	SETPAL1				;OVERRIGHT FIRST PALETTE

		LEA.L	PALETTE2,A0			;DOWNLOAD A PALETTE FOR THE SPRITES TO USE
		BSR	SETPAL2				;OVERRIGHT SECOND PALETTE	

		JSR	DUMPCOLS			;COPY ALL PALETTES TO CRAM (COLOUR RAM)

		move.W	#$80+160-130,player1X		;player1'S X START POSITION
		move.W	#$80+112-13,player1Y		;player1'S Y START POSITION
		move.W	#$80+160+130,player2X		;player1'S X START POSITION
		move.W	#$80+112-13,player2Y		;player1'S Y START POSITION
		move.W	#$80+80+80,BallX		;player1'S X START POSITION
		move.W	#$80+112-13,BallY		;player1'S Y START POSITION
		move.W 	#1,BallD			;puts 01 in to BallD
		RTS

;------------------------------
;	MAIN GAME LOOP
;------------------------------
MAIN:		WAITVBI					;WAITS FOR THE START OF THE NEXT FRAME
;add SPRITES
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		move.W	#1,D7

;-------------player stuff-------------

;player 1
		move.W	player1Y,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		move.W	#S_1X3,D0			;SIZE 2X4 CHARACTERS
		add.W	D7,D0				;add CURRENT SPRITE NUMBER
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		move.W	#S_PAL2+$1000/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		move.W	player1X,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		addq.W	#1,D7
;player 2							
		move.W	player2Y,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		move.W	#S_1X3,D0			;SIZE 2X4 CHARACTERS
		add.W	D7,D0				;add CURRENT SPRITE NUMBER
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		move.W	#S_PAL2+$1000/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		move.W	player2X,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		addq.W	#1,D7				;move ON TO NEXT SPRITE NUMBER

							;A1=POINTER TO NEXT SPRITE ENTRY
							;D7=NEXT SPRITE NUMBER

;-------------Ball stuff-------------

;Ball							
		move.W	BallY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		move.W	#S_1X1,D0			;SIZE OF CHARACTERS
		add.W	D7,D0				;add CURRENT SPRITE NUMBER
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		move.W	#S_PAL2+$1100/32,D0		;PALETTE NUMBER + VRAM LOCATION/32 in to D0
		move.W	D0,(A1)+			;WRITE TO SPRITE TABLE 
		move.W	BallX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		addq.W	#1,D7				;move ON TO NEXT SPRITE NUMBER

							;A1=POINTER TO NEXT SPRITE ENTRY
							;D7=NEXT SPRITE NUMBER
;END
		move.L	#$10000,(A1)+			;TERMINATE SPRITE LIST
		move.L	#1,(A1)+			;	"  "
		
;-------------hit detection-------------

		move.w	BallX,D3			;put BallX in to D3
		move.w	BallY,D4			;put BallY in to D4
		move.b	BallD,D5			;put BallD in to D5	
		
		cmp.b	#1,d5				;if d5 (BallD) = 0
		beq	@right				;goto right

;------------- left bit-------------	

		move.w 	player1X,d0			;put player1X in to d0
		add.b	#8,D0				;adds 8 to D0 (player1X)
		cmp.b 	D0,D3				;if d3 = d0
		beq	@Lmid				;goto Lmid
		jmp	@Ball_code			;goto Ball_code




;-------------Right bit-------------

@right:
		move.w 	player2X,d1			;put player2X in to D1
		sub.b	#8,D1				;adds 8 to D1 (player2x)
		cmp.b 	D1,D3				;If D1(player2X) = D3(BallX)
		beq	@Rmid				;goto Rmid (Right middle)
		jmp	@Ball_code			;goto Ball_code (Ball movement code)
	
	
;-------------left paddle hits-------------


;@Luphit:
;		move.w	#1,BallD     			;put 0 in BallD (Makes Ball go Right)
;		add.b	#1,BallYM  			;adds 1 to the y movement 
;		jmp	@Ball_code			;goto Ball_code (Ball movement code)

@Lmid:
		move.b	#1,BallD     			;put 0 in BallD (Makes Ball go Right)
		jmp	@Ball_code			;goto Ball_code (Ball movement code)

;@Ldownhit:
;		move.w	#1,BallD     			;put 0 in BallD (Makes Ball go Right)
;		sub.b	#1,BallYM     			
;		jmp	@Ball_code			;goto Ball_code (Ball movement code)



;-------------right paddle hits-------------

;@Ruphit:
;		move.W	#0,BallD 
;		add.b	#1,ballYM
;		jmp	@Ball_code			;goto Ball_code (Ball movement code)

@Rmid:
		move.b	#0,BallD     			;put 1 in BallD (Makes Ball go left)
		jmp	@Ball_code			;goto Ball_code (Ball movement code)
;@Rdownhit:
;		move.W	#0,BallD 
;		sub.b	#1,BallYM 
;		jmp	@Ball_code			;goto Ball_code (Ball movement code)

;-------------miss-------------
@miss:
		jmp	@Ball_code			;goto Ball_code (Ball movement code)

;---top and bottom barrier---		
;		move.w	BallY,d0
;		move.w	Tbar,d1
;		cmp.w	d0,d1
;		
;
;

;Ball movement code
@Ball_code:
		cmp.w	#0,d5				;if d5 = 0
		beq	@skip				;goto skip
		add.w	#2, BallX			;add 2 to BallX - this is important as it will hit @skip so this is needed to get a +1 movment going right
@skip:
		sub.w	#1, BallX			;sub 1 to BallX - makes it go left


	

;move player1
		btst	#J_DOWN,JOYPAD0
		bne.S	@move1
		add.W	#1,player1Y	
@move1:
		btst	#J_UP,JOYPAD0
		bne.S	@move2
		SUB.W	#1,player1Y	
;move player2
@move2:
		btst	#J_BUT_A,JOYPAD0
		bne.S	@move3
		SUB.W	#1,player2Y	
		
@move3:
		btst	#J_BUT_B,JOYPAD0
		bne.S	@move4
		add.W	#1,player2Y
;Ball move		
@move4:
		btst	#J_LEFT,JOYPAD0
		bne.S	@move5
		move.W	#1,BallD
		
@move5:
		btst	#J_RIGHT,JOYPAD0
		bne.S	@NORING
		move.W	#0,BallD

@NORING:

		BRA	MAIN				;LOOP BACK TO WAIT FOR NEXT FRAME
		
;----------------------------------------------------------
;		USER VBI ROUTINES
;		- PUT TIME CRITICAL code THAT MUST CALLED DURING THE VERTICAL BLANK HERE
;----------------------------------------------------------
USERVBI:	LEA.L	VDP_DATA,A1
			LEA.L	VDP_CONTROL,A2
;SET HORIZONTAL OFFSETS
;		move.L	#$7C000003,(A2)
;		move.L	PLAYX,(A1)			;THIS TELLS THE VDP (VISUAL DISPLAY PROCESSOR) WHAT X POSITION THE PLAYFIELDS SHOULD BE AT

;SET VERTICAL OFFSETS
;		move.L	#$40000010,(A2)			;THIS TELLS THE VDP WHAT Y POSITION THE PLAYFIELDS SHOULD BE AT
;		move.L	PLAYY,(A1)

;COPY SPRITE TABLE TO VRAM
		JSR	SPRITEDUMP
;READ JOYPAD
		BSR	READJOY				;READ THE JOYPAD

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
BallGFX:
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

