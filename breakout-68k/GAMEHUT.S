;----------------------------------------------------------
;		Breakout-clone v0.2 (00:18 13/10/2021) 
;		BY Joe
;----------------------------------------------------------
		INCLUDE	SYSTEM.S		;INCLUDES LOTS OF SYSTEM code TO MAKE ALL THIS POSSIBLE (hopefully replase later) By Jon Burton (GameHut)

;OK so this was forked from my own pong revolution (pong clone), as I suddenly realised it basicaly
;was the same game, so I desided to work on this to further my learning as well as pong,

;first plan is to shorten the paddle and invert it (depens on the version of breakout)
;I will shorten the paddle so there is a center that I can point to as 0 so I don't need any complex code
;second is to make a full box (as the code is the same as PR I can port that to PR as well)
;third is to make the paddle dection actully work
;forth is to work on a hit box for the bricks (the hardest part),
;bonus, otimise and fix code that can be shared in to PR


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
player1S:	RS.W	1				;Player1'S score

brickx:		rs.w 	1				;brickx 
bricky:		rs.W	1				;bricky

BallX:		RS.L	1				;Ball'S X position
BallXM:		RS.L	1				;Ball'S X movement (X speed)
bxmod:		rs.W	1				;ball X modifier
BallY:		RS.W	1				;Ball'S Y position
BallYM:		RS.W	1				;Ball'S Y movement (Y speed)
bymod:		rs.W	1				;ball y modifier


TBar:		RS.W	1				;top barrier
BBar:		RS.W	1				;bottom barrier
LBar:		RS.W	1				;left barrier
RBar:		RS.W	1				;right barrier

TEMPSCREEN:	RS.B	4096			;RAM TO BUILD TEMPORARY SCREEN MAP
ENDVARS:	RS.B	0

;----------------------------------------------------------
;		INITIALISE USER STUFF
;		- THIS IS WHERE YOU SET UP STUFF BEFORE YOU BEGIN
;----------------------------------------------------------
USERINIT:	
		DMADUMP	BallGFX,1*32,$1100			;DUMP 1 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1100 (MAP GRAPHICS)
		DMADUMP	SPRITEGFX,4*32,$1000		;DUMP 3 CHARACTERS (SIZE 32 BYTES EACH) TO VRAM LOCATION $1000 (SPRITE GRAPHICS)

		lea.l	TEMPSCREEN,A0
		
		DMADUMP	TEMPSCREEN,4096,$C000
;----------------------------------------------------------
;		Palettes
;----------------------------------------------------------
		LEA.L	PALETTE2,A0					;DOWNLOAD A PALETTE FOR THE SPRITES TO USE
		BSR	SETPAL2							;OVERRIGHT SECOND PALETTE	

		JSR	DUMPCOLS						;COPY ALL PALETTES TO CRAM (COLOUR RAM)

		move.W	#$80+80+80,player1X			;player1'S X START POSITION
		move.W	#$80+220-13,player1Y		;player1'S Y START POSITION
		move.W	#$80+80+80,BallX			;ball X START POSITION
		move.W	#$80+112-13,BallY			;ball Y START POSITION
		move.W	#$80+14-13,TBar				;ball Y START POSITION
		move.W	#$80+230-13,BBar			;ball Y START POSITION	
		move.W	#$80+160-140,LBar			;player1'S X START POSITION
		move.W	#$80+160+140,RBar			;player1'S X START POSITION
		move.W	#2,BallXM
		;move.B	#1,BallYD
		move.w	#2,ballYM
		RTS

;------------------------------
;	MAIN GAME LOOP
;------------------------------
MAIN:		WAITVBI							;WAITS FOR THE START OF THE NEXT FRAME
;add SPRITES
		LEA.L	SPRITETEMP,A1				;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		move.W	#1,D7

;-------------player stuff-------------

;player 1
		move.W	player1Y,(A1)+				;Y POSITION ($80 IS TOP OF SCREEN)
		move.W	#S_4X1,D0					;SIZE 1X3 (X-Y )CHARACTERS
		add.W	D7,D0						;add CURRENT SPRITE NUMBER
		move.W	D0,(A1)+					;WRITE TO SPRITE TABLE
		move.W	#S_PAL2+$1000/32,D0			;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		move.W	D0,(A1)+					;WRITE TO SPRITE TABLE
		move.W	player1X,(A1)+				;X POSITION ($80 IS LEFT OF SCREEN)

		addq.W	#1,D7

;Ball							
		move.W	BallY,(A1)+					;Y POSITION ($80 IS TOP OF SCREEN)
		move.W	#S_1X1,D0					;SIZE 1X1 (X-Y) CHARACTERS
		add.W	D7,D0						;add CURRENT SPRITE NUMBER
		move.W	D0,(A1)+					;WRITE TO SPRITE TABLE
		move.W	#S_PAL2+$1100/32,D0			;PALETTE NUMBER + VRAM LOCATION/32 in to D0
		move.W	D0,(A1)+					;WRITE TO SPRITE TABLE 
		move.W	BallX,(A1)+					;X POSITION ($80 IS LEFT OF SCREEN)

		addq.W	#1,D7						;move ON TO NEXT SPRITE NUMBER

											;A1=POINTER TO NEXT SPRITE ENTRY
											;D7=NEXT SPRITE NUMBER

;END
		move.L	#$10000,(A1)+				;TERMINATE SPRITE LIST
		move.L	#1,(A1)+					;	"  "
		
;-------------Paddle Hit Detection Start-------------

		move.w	BallX,D3					;put BallX in to D3
		move.w	BallY,D4					;put BallY in to D4
;@hitbox:									;right part of brick
;		move.w 	player1x,d1
;		cmp.W	d3,d1
;		ble.s	@hitbox2
;		bra.s 	@boarder
;@hitbox2:									;left part of brick
;		add.w	#10,d1
;		cmp.W	d3,d1
;		bge.s	@hitbox3
;		bra.s 	@boarder
;@hitbox3:									;top of brick
;		move.w 	player1Y,d1
;		cmp.w	d4,d1
;		ble.S	@hitbox4
;		bra.s 	@boarder
;@hitbox4:									;bottom part of brick
;		add.w	#8,d1
;		cmp.W	d4,d1
;		bge.s	@BHit

;paddle hit box stuff
@paddley:
		move.w 	player1Y,d1
		cmp.w	d4,d1
		beq		@padsetup
		bra.s	@boarder
@padsetup:
		move.B	#12,d5
		move.b 	#23-1,d2
		move.w 	player1x,d1
		add.w	#04,d1
@padloop:
		SUB.b	#1,d5
		SUB.w	#1,d1
		cmp.W	d1,d3
		beq		@calX
		dbra	d2,@padloop
		bra.s	@boarder

@calx:
		move.B	d5,bxspeed
		bra.S	@Side

@boarder:									;boarder
		move.W	Tbar, d1
		cmp.w	d1,d4
		beq		@BHit
		move.W	Bbar,d1
		cmp.w	d1,d4
		beq		@BHit
		bra		@sideboarder
@BHit:	
		move.w	ballYM,d0
		neg.w	d0							;flip Y movement

@sideboarder:
		move.w  LBar,d1
		cmp.w	d1,D3
		beq.W	@Side
		move.w  RBar,d1
		cmp.w	d1,D3
		beq.W	@Side
		bra		@Ball_code
@Side:
		move.w	ballXM,d2
		neg.w	d2							;flip X movement

;Ball movement code
@Ball_code:
		



		add.w	d0,bally
		move.w 	d0,ballym
;		add.w	d2,BallX
;		move 	d2,ballXM

;move player1
		btst	#J_RIGHT,JOYPAD0
		bne.S	@move1
		add.W	#2,player1x	
@move1:
		btst	#J_LEFT,JOYPAD0
		bne.S	@NORING
		SUB.W	#2,player1x		
@NORING:

		BRA	MAIN							;LOOP BACK TO WAIT FOR NEXT FRAME
		
;----------------------------------------------------------
;		USER VBI ROUTINES
;		- PUT TIME CRITICAL code THAT MUST CALLED DURING THE VERTICAL BLANK HERE
;----------------------------------------------------------
USERVBI:	LEA.L	VDP_DATA,A1
			LEA.L	VDP_CONTROL,A2
;SET HORIZONTAL OFFSETS
;		move.L	#$7C000003,(A2)
;		move.L	PLAYX,(A1)					;THIS TELLS THE VDP (VISUAL DISPLAY PROCESSOR) WHAT X POSITION THE PLAYFIELDS SHOULD BE AT

;SET VERTICAL OFFSETS
;		move.L	#$40000010,(A2)				;THIS TELLS THE VDP WHAT Y POSITION THE PLAYFIELDS SHOULD BE AT
;		move.L	PLAYY,(A1)

;COPY SPRITE TABLE TO VRAM
		JSR	SPRITEDUMP
;READ JOYPAD
		BSR	READJOY							;READ THE JOYPAD

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
SPRITEGFX:									;paddle (both paddles are the same gfx)
		DC.B	$04,$44,$44,$44				;1
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$04,$44,$44,$44
				
		DC.B	$44,$44,$44,$45				;2
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45

		DC.B	$44,$44,$44,$44				;2
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		DC.B	$44,$44,$44,$44
		
		DC.B	$44,$44,$44,$00				;3
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$40
		DC.B	$44,$44,$44,$00
;----------------------------------------------------------
BallGFX:									;Ball
		DC.B	$04,$44,$00,$00				
		DC.B	$44,$44,$40,$00
		DC.B	$44,$44,$40,$00
		DC.B	$44,$44,$40,$00
		DC.B	$04,$44,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
;----------------------------------------------------------
BrickGFX:
		DC.B	$55,$55,$55,$55				;1
		DC.B	$54,$44,$44,$44
		DC.B	$54,$44,$44,$44
		DC.B	$54,$44,$44,$44
		DC.B	$54,$44,$44,$44
		DC.B	$54,$44,$44,$44
		DC.B	$54,$44,$44,$44
		DC.B	$55,$55,$55,$55
				
		DC.B	$55,$55,$55,$55				;2
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$44,$44,$44,$45
		DC.B	$55,$55,$55,$45
;----------------------------------------------------------
;Level tile maps
;----------------------------------------------------------
Level1:
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		DC.B	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1




;----------------------------------------------------------
;		USER PALETTES
;----------------------------------------------------------
PALETTE2:									;all sprites use this one
		DC.W	$0000,$0000,$0F80,$08CE	
		DC.W	$0EEE,$00E0,$000E,$00EE
		DC.W	$0088,$0044,$0066,$0AAA
		DC.W	$0666,$0444,$0222,$0888

