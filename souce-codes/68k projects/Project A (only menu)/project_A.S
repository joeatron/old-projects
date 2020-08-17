;----------------------------------------------------------
;project_A ver0.3
;BY joe
;----------------------------------------------------------

;----------------------------------------------------------
;rom header
;----------------------------------------------------------
		include SYSTEM_A.S
;----------------------------------------------------------
;veriabes
;----------------------------------------------------------
		RSSET	USERRAM
PLAYX:		RS.L	0
PLAY1X:		RS.W	1			;X POSITION OF PLAYFIELD 1
PLAY2X:		RS.W	1			;X POSITION OF PLAYFIELD 2
PLAYY:		RS.L	0
PLAY1Y:		RS.W	1			;Y POSITION OF PLAYFIELD 1
PLAY2Y:		RS.W	1			;Y POSITION OF PLAYFIELD 2
;arrowx:	rs.w	1			
;arrowy:	rs.w	1
bax:		rs.w	1
bay:		rs.w	1
bbx:		rs.w	1
bby:		rs.w	1
bcx:		rs.w	1
bcy:		rs.w	1
start1x:	rs.w	1			
start1y:	rs.w	1
start2x:	rs.w	1			
start2y:	rs.w	1
option1x:	rs.w	1			
option1y:	rs.w	1		
option2x:	rs.w	1			
option2y:	rs.w	1			
extra1x:	rs.w	1			
extra1y:	rs.w	1
extra2x:	rs.w	1			
extra2y:	rs.w	1
nomap1y:	rs.w	1	
nomap1x:	rs.w	1
nomap2y:	rs.w	1	
nomap2x:	rs.w	1
nomap3y:	rs.w	1	
nomap3x:	rs.w	1
nomap4y:	rs.w	1	
nomap4x:	rs.w	1
stageselect1x:	rs.w	1
stageselect1y:	rs.w	1
stageselect2x:	rs.w	1
stageselect2y:	rs.w	1
stageselect3x:	rs.w	1
stageselect3y:	rs.w	1
charselect1x:	rs.w	1
charselect1y:	rs.w	1
charselect2x:	rs.w	1
charselect2y:	rs.w	1
charselect3x:	rs.w	1
charselect3y:	rs.w	1
charselect4x:	rs.w	1
charselect4y:	rs.w	1			
healfbar:	rs.w	1
player1:	rs.w	1
player1x:	rs.w	1
player1y:	rs.w	1
player1d:	rs.w	1
player2:	rs.w	1
player2x:	rs.w	1
player2y:	rs.w	1
player2d:	rs.w	1
cpuplayer:	rs.w	1
cpuplayerx:	rs.w	1
cpuplayery:	rs.w	1
cpuplayerd:	rs.w	1
TEMPSCREEN:	RS.B	4096			;RAM TO BUILD TEMPORARY SCREEN MAP
ENDVARS:	RS.B	0
;------------------------
;USERINIT
;------------------------
USERINIT:
		MOVE.W	#0,PLAYX		;SET START X POSITION TO ZERO
		MOVE.W	#0,PLAYY		;SET START Y POSITION TO ZERO

		MOVE.W	#0,PLAY1X		
		MOVE.W	#0,PLAY1Y		

		MOVE.W	#0,PLAY2X		
		MOVE.W	#0,PLAY2Y		

		DMADUMP	ba,1*32,$700
		DMADUMP	bb,1*32,$800
		DMADUMP	bc,1*32,$900
;		DMADUMP	arrow,1*32,$1000		
		DMADUMP	start1,4*32,$1000+$100
		DMADUMP	start2,1*32,$1000+$200	
		DMADUMP	option1,4*32,$1000+$300
		DMADUMP	option2,2*32,$1000+$400
		DMADUMP	extra1,4*32,$1000+$500				
		DMADUMP	extra2,1*32,$1000+$600
		DMADUMP	nomap1,1*32,$1000+$700
		DMADUMP	stageselect1,4*32,$1000+$800				
		DMADUMP	stageselect2,4*32,$1000+$900
		DMADUMP	stageselect3,3*32,$1000+$1000
		DMADUMP	nomap2,1*32,$1000+$A00
		DMADUMP	nomap3,1*32,$1000+$B00
		DMADUMP	nomap4,1*32,$1000+$C00
		DMADUMP	charselect1,4*32,$1000+$D00				
		DMADUMP	charselect2,4*32,$1000+$E00
		DMADUMP	charselect3,4*32,$1000+$F00
		DMADUMP	charselect4,3*32,$2000
		DMADUMP	robotidle,8*32,$2100
;		DMADUMP	robotrun1,8*32,$2200
;		DMADUMP	robotrun2,8*32,$2300
;		DMADUMP	robotrun3,8*32,$2400
;		DMADUMP	robotarm1,8*32,$2500
;		DMADUMP	robotarm2,8*32,$2600
;		DMADUMP	robotpunch1,1*32,$2700
;		DMADUMP	robotpunch2,1*32,$2800
;		DMADUMP	robotblast1,1*32,$2900
;		DMADUMP	robotblast2,1*32,$3000
;		DMADUMP	robotblast3,1*32,$3100
		LEA.L	TEMPSCREEN,A0		;POINT A0 TO TEMPORARY BUFFER IN RAM TO BUILD MAP BEFORE WE COPY TO VRAM		
		
		DMADUMP	TEMPSCREEN,4096,$C000	;COPY TEMPSCREEN WHICH IS 4096 BYTES IN SIZE TO VRAM ADDRESS $C000

		LEA.L	PALETTE1,A0		
		BSR	SETPAL1			

		LEA.L	PALETTE2,A0		
		BSR	SETPAL2			
		
		LEA.L	PALETTE3,A0		
		BSR	SETPAL3			

		LEA.L	PALETTE4,A0		
		BSR	SETPAL4		
		
		JSR	DUMPCOLS		;COPY ALL PALETTES TO CRAM (COLOUR RAM)

		move.w 	#$30+160-8,start1x
		move.w 	#$80+160-13,start1y
		move.w 	#$30+192-8,start2x
		move.w 	#$80+160-13,start2y
		move.w 	#$30+160-8,option1x
		move.w 	#$90+160-13,option1y
		move.w 	#$30+192-8,option2x
		move.w 	#$90+160-13,option2y
		move.w 	#$30+160-8,extra1x
		move.w 	#$A0+160-13,extra1y
		move.w 	#$30+192-8,extra2x
		move.w 	#$A0+160-13,extra2y
;		move.w 	#$C0+160-8,arrowx
;		move.w 	#$80+160-13,arrowy
		move.w 	#$10+160-8,bax
		move.w 	#$80+160-13,bay
		move.w 	#$10+160-8,bbx
		move.w 	#$90+160-13,bby
		move.w 	#$10+160-8,bcx
		move.w 	#$A0+160-13,bcy
		move.w	#$80+150-8,nomap1X	
		move.w	#$80+200-13,nomap1Y
		move.w	#$80+160-8,nomap2X	
		move.w	#$80+200-13,nomap2Y
		move.w	#$80+170-8,nomap3X	
		move.w	#$80+200-13,nomap3Y
		move.w	#$80+180-8,nomap4X	
		move.w	#$80+200-13,nomap4Y
		move.w 	#$60+160-8,stageselect1x
		move.w 	#$80+40-13,stageselect1y
		move.w 	#$60+192-8,stageselect2x
		move.w 	#$80+40-13,stageselect2y
		move.w 	#$60+224-8,stageselect3x
		move.w 	#$80+40-13,stageselect3y
		move.w 	#$60+160-8,charselect1x
		move.w 	#$80+40-13,charselect1y
		move.w 	#$60+192-8,charselect2x
		move.w 	#$80+40-13,charselect2y
		move.w 	#$60+224-8,charselect3x
		move.w 	#$80+40-13,charselect3y
		move.w 	#$60+256-8,charselect4x
		move.w 	#$80+40-13,charselect4y			
		rts
;----------------------------------------------------------
;main
;----------------------------------------------------------
MAIN:
		WAITVBI				;WAITS FOR THE START OF THE NEXT FRAME
		bra	menu
		
;------------------------
;menu(2)
;------------------------
menu:	
		WAITVBI
;ADD SPRITES
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		MOVE.W	#1,D7				;SPRITE NUMBER
;arrow
;		MOVE.W	arrowY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
;		MOVE.W	#S_1X1,D0			;SIZE 2X4 CHARACTERS
;		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
;		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
;		MOVE.W	#S_PAL1+$1000/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
;		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
;		MOVE.W	arrowX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)
;
;		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
;ba
		MOVE.W	baY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X1,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL1+$700/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	baX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
;bb
		MOVE.W	bbY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X1,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL1+$800/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	bbX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
;bc
		MOVE.W	bcY,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_1X1,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL1+$900/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	bcX,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
;start1
		MOVE.W	start1Y,(A1)+			;Y POSITION ($80 IS TOP OF SCREEN)
		MOVE.W	#S_4X1,D0			;SIZE 2X4 CHARACTERS
		ADD.W	D7,D0				;ADD CURRENT SPRITE NUMBER
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	#S_PAL1+$1100/32,D0		;PALETTE NUMBER+GRAPHIC VRAM LOCATION/32
		MOVE.W	D0,(A1)+			;WRITE TO SPRITE TABLE
		MOVE.W	start1X,(A1)+			;X POSITION ($80 IS LEFT OF SCREEN)

		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
;start2
		MOVE.W	start2Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1200/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	start2X,(A1)+			

		ADDQ.W	#1,D7				
;option1
		MOVE.W	option1Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1300/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	option1X,(A1)+			
		ADDQ.W	#1,D7				
;option2
		MOVE.W	option2Y,(A1)+			
		MOVE.W	#S_2X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1400/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	option2X,(A1)+
			
		ADDQ.W	#1,D7				
;extra1

		MOVE.W	extra1Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1500/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	extra1X,(A1)+			

		ADDQ.W	#1,D7					
;extra2

		MOVE.W	extra2Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1600/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	extra2X,(A1)+			
		ADDQ.W	#1,D7				
		
;FINISHED ADDING SPRITES
		MOVE.L	#$10000,(A1)+			;TERMINATE SPRITE LIST
		MOVE.L	#1,(A1)+			;	"  "
		
menumove0:
		BTST	#J_BUT_A,JOYPAD0
		BNE.S	menumove1
		bra	start
menumove1:
		BTST	#J_BUT_B,JOYPAD0
		BNE.S	menumove2
		bra	options
menumove2:
		BTST	#J_BUT_C,JOYPAD0
		BNE.W	menu
		bra	extra

		bra	menu
;--------------------
;start(3)
;--------------------
;start:
		bra	chariter
		move	d5,d6				;replace later
;----------
;chariter(4)
;----------
chariter:
		WAITVBI
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		MOVE.W	#1,D7				;SPRITE NUMBER
		MOVE.W	charselect1Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1D00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	charselect1X,(A1)+
		ADDQ.W	#1,D7
		MOVE.W	charselect2Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1E00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	charselect2X,(A1)+
		ADDQ.W	#1,D7
		MOVE.W	charselect3Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1F00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	charselect3X,(A1)+
		ADDQ.W	#1,D7
		MOVE.W	charselect4Y,(A1)+			
		MOVE.W	#S_3X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$2000/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	charselect4X,(A1)+
		ADDQ.W	#1,D7
		MOVE.L	#$10000,(A1)+			;TERMINATE SPRITE LIST
		MOVE.L	#1,(A1)+
csmove1:

		BTST	#J_BUT_B,JOYPAD0
		BNE.W	csmove2
		bra.W 	stage
csmove2:	
		BTST	#J_BUT_A,JOYPAD0
		BNE.W 	chariter
		move	d5,d6

;----------
;stage(4)
;----------
stage:		
		WAITVBI				;WAITS FOR THE START OF THE NEXT FRAME
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		MOVE.W	#1,D7				;SPRITE NUMBER
		MOVE.W	nomap1Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1700/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	nomap1X,(A1)+
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER			
		MOVE.W	nomap2Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1A00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	nomap2X,(A1)+
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER
		MOVE.W	nomap3Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1B00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	nomap3X,(A1)+
		ADDQ.W	#1,D7				;MOVE ON TO NEXT SPRITE NUMBER			
		MOVE.W	nomap4Y,(A1)+			
		MOVE.W	#S_1X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1C00/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	nomap4X,(A1)+			
		ADDQ.W	#1,D7	
		MOVE.W	stageselect1Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1800/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	stageselect1X,(A1)+			
		ADDQ.W	#1,D7	
		MOVE.W	stageselect2Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$1900/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	stageselect2X,(A1)+		
		ADDQ.W	#1,D7
		MOVE.W	stageselect3Y,(A1)+			
		MOVE.W	#S_4X1,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$2000/32,D0		
		MOVE.W	D0,(A1)+			
		MOVE.W	stageselect3X,(A1)+		
	
		MOVE.L	#$10000,(A1)+			;TERMINATE SPRITE LIST
		MOVE.L	#1,(A1)+				
smove1:
		BTST	#J_BUT_B,JOYPAD0
		BNE.W	smove2
		bra.W 	play
smove2:	
		BTST	#J_BUT_A,JOYPAD0
		BNE.W 	stage
		move	d5,d6

;----------
;play(4)
;----------
play:
		WAITVBI
		move.w	$2100,D1			;replace later		
		LEA.L	SPRITETEMP,A1			;POINT TO TEMPORARY MEMORY TO BUILD SPRITE LIST
		MOVE.W	#1,D7				;SPRITE NUMBER		MOVE.W	robotidleY,(A1)+			
		MOVE.W	player1Y,(A1)+			
		MOVE.W	#S_4X2,D0			
		ADD.W	D7,D0				
		MOVE.W	D0,(A1)+			
		MOVE.W	#S_PAL1+$D1/32,D0
		ADD.W	player1D,D0			;ADD SONIC'S DIRECTION		
		MOVE.W	D0,(A1)+			
		MOVE.W	player1X,(A1)+
	


;player1move1:
;		BTST	#J_,JOYPAD0
;		BNE.W	player1move2
player1move2:
		BTST	#J_RIGHT,JOYPAD0
		BNE.W	player1move3
		add.w	#1,player1x
player1move3:
		BTST	#J_left,JOYPAD0
		BNE.W	player1move4
		sub.w	#1,player1x
player1move4:
		BTST	#J_down,JOYPAD0
		BNE.W	player1move5
		add.w	#1,player1y
player1move5:
		BTST	#J_up,JOYPAD0
		BNE.W	player1move6
		sub.w	#1,player1y
player1move6:
		BTST	#J_but_a,JOYPAD0
		BNE.W	player1move7
;		add	d3,d4
player1move7:
		BTST	#J_but_b,JOYPAD0
		BNE.W	player1move8
;		add	d3,d4
player1move8:
		BTST	#J_but_c,JOYPAD0
		BNE.W	back
;player2move1:
;player2move2:
;player2move3:
;player2move4:
;player2move5:
;player2move6:
;player2move7:
;player2move8:


back:
		bra	play
		
;--------------------
;C editer(3)
;--------------------
;--------------------
;options(3)
;--------------------
options:
		move	d5,d6				;replace later
		bra	options

;----------
;extras(4)
;----------
extra:
		move	d5,d6				;replace later
		bra	extra
;-------
;extra game(5)
;-------
		

;-------------------------
USERVBI:	LEA.L	VDP_DATA,A1
		LEA.L	VDP_CONTROL,A2
;SET HORIZONTAL OFFSETS
		MOVE.L	#$7C000003,(A2)
;		MOVE.L	PLAYX,(A1)			;THIS TELLS THE VDP (VISUAL DISPLAY PROCESSOR) WHAT X POSITION THE PLAYFIELDS SHOULD BE AT

;SET VERTICAL OFFSETS
		MOVE.L	#$40000010,(A2)			;THIS TELLS THE VDP WHAT Y POSITION THE PLAYFIELDS SHOULD BE AT
;		MOVE.L	PLAYY,(A1)

;COPY SPRITE TABLE TO VRAM
		JSR	SPRITEDUMP
;READ JOYPAD
		BSR	READJOY				;READ THE JOYPAD

		RTS
;----------------------------------------------------------
;music
;----------------------------------------------------------

;----------------------------------------------------------
;sprights
;----------------------------------------------------------
ba:
		DC.B    $00, $07, $70, $00
		DC.B    $00, $70, $07, $00
		DC.B    $07, $02, $20, $70
		DC.B    $70, $20, $02, $07
		DC.B    $70, $22, $22, $07
		DC.B    $07, $20, $02, $70
		DC.B    $00, $70, $07, $00
		DC.B    $00, $07, $70, $00
bb:
		DC.B    $00, $07, $70, $00
		DC.B    $00, $70, $07, $00
		DC.B    $07, $06, $60, $70
		DC.B    $70, $60, $06, $07
		DC.B    $70, $66, $60, $07
		DC.B    $07, $60, $06, $70
		DC.B    $00, $76, $67, $00
		DC.B    $00, $07, $70, $00
bc:
		DC.B    $00, $07, $70, $00
		DC.B    $00, $70, $07, $00
		DC.B    $07, $03, $30, $70
		DC.B    $70, $30, $03, $07
		DC.B    $70, $30, $00, $07
		DC.B    $07, $30, $03, $70
		DC.B    $00, $73, $37, $00
		DC.B    $00, $07, $70, $00

;arrow:
;		DC.B    $00, $00, $00, $77
;		DC.B    $00, $00, $77, $97
;		DC.B    $00, $77, $99, $87
;		DC.B    $77, $99, $88, $97
;		DC.B    $77, $99, $88, $97
;		DC.B    $00, $77, $99, $87
;		DC.B    $00, $00, $77, $97
;		DC.B    $00, $00, $00, $77
start1:
		DC.B    $00, $11, $10, $00 ;S
		DC.B    $01, $10, $11, $00
		DC.B    $02, $22, $00, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $02, $22, $00
		DC.B    $01, $10, $11, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $00, $00, $00

		DC.B    $11, $11, $11, $10 ;T
		DC.B    $11, $11, $11, $10
		DC.B    $00, $22, $20, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $22, $20, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $00, $00, $00

		DC.B    $00, $01, $00, $00 ;A
		DC.B    $00, $11, $10, $00
		DC.B    $02, $22, $22, $00
		DC.B    $01, $10, $11, $00
		DC.B    $02, $22, $22, $00
		DC.B    $11, $00, $01, $10
		DC.B    $11, $00, $01, $10
		DC.B    $00, $00, $00, $00

		DC.B    $01, $11, $10, $00 ;R
		DC.B    $01, $10, $11, $00
		DC.B    $02, $20, $22, $00
		DC.B    $01, $11, $10, $00
		DC.B    $02, $22, $20, $00
		DC.B    $01, $10, $11, $00
		DC.B    $01, $10, $11, $00
		DC.B    $00, $00, $00, $00

start2:		DC.B    $11, $11, $11, $10 ;T
		DC.B    $11, $11, $11, $10
		DC.B    $00, $22, $20, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $22, $20, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $11, $10, $00
		DC.B    $00, $00, $00, $00

option1:
		DC.B    $05, $55, $55, $00
		DC.B    $55, $50, $55, $50
		DC.B    $66, $00, $06, $60
		DC.B    $55, $00, $05, $50
		DC.B    $66, $00, $06, $60
		DC.B    $55, $50, $55, $50
		DC.B    $05, $55, $55, $00
		DC.B    $00, $00, $00, $00

		DC.B    $05, $55, $50, $00
		DC.B    $05, $50, $55, $00
		DC.B    $06, $60, $66, $00
		DC.B    $05, $55, $50, $00
		DC.B    $06, $60, $00, $00
		DC.B    $05, $50, $00, $00
		DC.B    $05, $50, $00, $00
		DC.B    $00, $00, $00, $00

		DC.B    $55, $55, $55, $50
		DC.B    $55, $55, $55, $50
		DC.B    $00, $66, $60, $00
		DC.B    $00, $55, $50, $00
		DC.B    $00, $66, $60, $00
		DC.B    $00, $55, $50, $00
		DC.B    $00, $55, $50, $00
		DC.B    $00, $00, $00, $00

		DC.B    $05, $55, $00, $05
		DC.B    $05, $55, $00, $55
		DC.B    $06, $66, $00, $66
		DC.B    $05, $55, $00, $55
		DC.B    $06, $66, $00, $66
		DC.B    $05, $55, $00, $55
		DC.B    $05, $55, $00, $05
		DC.B    $00, $00, $00, $00
	
option2:	DC.B    $55, $55, $00, $05
		DC.B    $50, $55, $50, $05
		DC.B    $00, $06, $60, $06
		DC.B    $00, $05, $50, $05
		DC.B    $00, $06, $60, $06
		DC.B    $50, $55, $50, $05
		DC.B    $55, $55, $00, $05
		DC.B    $00, $00, $00, $00

		DC.B    $55, $00, $55, $00
		DC.B    $55, $50, $55, $00
		DC.B    $66, $60, $66, $00
		DC.B    $55, $55, $55, $00
		DC.B    $60, $66, $66, $00
		DC.B    $50, $55, $55, $00
		DC.B    $50, $05, $55, $00
		DC.B    $00, $00, $00, $00

extra1:
		DC.B    $44, $44, $40, $04
		DC.B    $44, $40, $00, $04
		DC.B    $33, $00, $30, $00
		DC.B    $44, $44, $40, $00
		DC.B    $33, $00, $30, $00
		DC.B    $44, $40, $00, $04
		DC.B    $44, $44, $40, $04
		DC.B    $00, $00, $00, $00

		DC.B    $40, $04, $40, $04
		DC.B    $44, $44, $40, $04
		DC.B    $33, $33, $00, $00
		DC.B    $04, $40, $00, $00
		DC.B    $33, $33, $00, $00
		DC.B    $44, $44, $40, $00	
		DC.B    $40, $04, $40, $00
		DC.B    $00, $00, $00, $00
		
		DC.B    $44, $44, $44, $00
		DC.B    $44, $44, $44, $00
		DC.B    $03, $33, $00, $00
		DC.B    $04, $44, $00, $00
		DC.B    $03, $33, $00, $00
		DC.B    $04, $44, $00, $00
		DC.B    $04, $44, $00, $00
		DC.B    $00, $00, $00, $00
	
		DC.B    $44, $44, $00, $00	
		DC.B    $44, $04, $40, $00
		DC.B    $33, $03, $30, $00
		DC.B    $44, $44, $00, $00
		DC.B    $33, $33, $00, $00
		DC.B    $44, $04, $40, $04
		DC.B    $44, $04, $40, $04
		DC.B    $00, $00, $00, $00

extra2:		DC.B    $00, $40, $00, $00
		DC.B    $04, $44, $00, $00
		DC.B    $33, $33, $30, $00
		DC.B    $44, $04, $40, $00
		DC.B    $33, $33, $30, $00
		DC.B    $40, $00, $44, $00
		DC.B    $40, $00, $44, $00
		DC.B    $00, $00, $00, $00
nomap1:
		DC.B    $77, $78, $87, $77
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $80, $07, $70, $08
		DC.B    $80, $07, $70, $08
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $77, $78, $87, $77
nomap2:
		DC.B    $77, $78, $87, $77
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $80, $05, $50, $08
		DC.B    $80, $05, $50, $08
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $77, $78, $87, $77
nomap3:
		DC.B    $77, $78, $87, $77
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $80, $03, $30, $08
		DC.B    $80, $03, $30, $08
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $77, $78, $87, $77
nomap4:
		DC.B    $77, $78, $87, $77
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $80, $01, $10, $08
		DC.B    $80, $01, $10, $08
		DC.B    $70, $00, $00, $07
		DC.B    $70, $00, $00, $07
		DC.B    $77, $78, $87, $77
stageselect1:	
		DC.B    $00, $77, $70, $00 ;S
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $00, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $08, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $77, $70 ;T
		DC.B    $77, $77, $77, $70
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $00, $07, $00, $00 ;A
		DC.B    $00, $77, $70, $00
		DC.B    $08, $88, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $88, $00
		DC.B    $77, $00, $07, $70
		DC.B    $77, $00, $07, $70
		DC.B    $00, $00, $00, $00

		DC.B    $00, $77, $70, $00 ;G
		DC.B    $07, $70, $07, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $00, $77, $70
		DC.B    $88, $00, $08, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00
stageselect2:
		DC.B    $77, $77, $70, $00;E
		DC.B    $77, $70, $00, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $77, $70, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $70, $00, $00
		DC.B    $77, $77, $70, $00
		DC.B    $00, $00, $00, $00
		
		DC.B    $00, $77, $70, $00 ;S
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $00, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $08, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $70, $00;E
		DC.B    $77, $70, $00, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $77, $70, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $70, $00, $00
		DC.B    $77, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $07, $70, $00, $00;L
		DC.B    $07, $70, $00, $00
		DC.B    $08, $80, $00, $00
		DC.B    $07, $70, $00, $00
		DC.B    $08, $80, $00, $00
		DC.B    $07, $77, $77, $00
		DC.B    $07, $77, $77, $00
		DC.B    $00, $00, $00, $00
stageselect3:
		DC.B    $77, $77, $70, $00;E
		DC.B    $77, $70, $00, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $77, $70, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $70, $00, $00
		DC.B    $77, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $07, $77, $70, $00;C
		DC.B    $77, $70, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $07, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $70, $77, $00
		DC.B    $07, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $77, $70 ;T
		DC.B    $77, $77, $77, $70
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00
charselect1:

		DC.B    $07, $77, $70, $00;C
		DC.B    $77, $70, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $07, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $70, $77, $00
		DC.B    $07, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $00, $77, $00;H
		DC.B    $77, $00, $77, $00
		DC.B    $88, $00, $88, $00
		DC.B    $77, $77, $77, $00
		DC.B    $88, $00, $88, $00
		DC.B    $77, $00, $77, $00
		DC.B    $77, $00, $77, $00
		DC.B    $00, $00, $00, $00

		DC.B    $00, $07, $00, $00 ;A
		DC.B    $00, $77, $70, $00
		DC.B    $08, $88, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $88, $00
		DC.B    $77, $00, $07, $70
		DC.B    $77, $00, $07, $70
		DC.B    $00, $00, $00, $00

		DC.B    $07, $77, $70, $00 ;R
		DC.B    $07, $70, $77, $00
		DC.B    $08, $80, $88, $00
		DC.B    $07, $77, $70, $00
		DC.B    $08, $88, $80, $00
		DC.B    $07, $70, $77, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $00, $00, $00
charselect2:
		DC.B    $00, $07, $00, $00 ;A
		DC.B    $00, $77, $70, $00
		DC.B    $08, $88, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $88, $00
		DC.B    $77, $00, $07, $70
		DC.B    $77, $00, $07, $70
		DC.B    $00, $00, $00, $00

		DC.B    $07, $77, $70, $00;C
		DC.B    $77, $70, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $07, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $70, $77, $00
		DC.B    $07, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $77, $70 ;T
		DC.B    $77, $77, $77, $70
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $07, $77, $77, $00;E
		DC.B    $07, $77, $00, $00
		DC.B    $08, $80, $08, $00
		DC.B    $07, $77, $77, $00
		DC.B    $08, $80, $08, $00
		DC.B    $07, $77, $00, $00
		DC.B    $07, $77, $77, $00
		DC.B    $00, $00, $00, $00
charselect3:
		DC.B    $07, $77, $70, $00 ;R
		DC.B    $07, $70, $77, $00
		DC.B    $08, $80, $88, $00
		DC.B    $07, $77, $70, $00
		DC.B    $08, $88, $80, $00
		DC.B    $07, $70, $77, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $00, $00, $00

		DC.B    $00, $77, $70, $00 ;S
		DC.B    $07, $70, $77, $00
		DC.B    $08, $88, $00, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $08, $88, $00
		DC.B    $07, $70, $77, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $70, $00;E
		DC.B    $77, $70, $00, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $77, $70, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $70, $00, $00
		DC.B    $77, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $07, $70, $00, $00;L
		DC.B    $07, $70, $00, $00
		DC.B    $08, $80, $00, $00
		DC.B    $07, $70, $00, $00
		DC.B    $08, $80, $00, $00
		DC.B    $07, $77, $77, $00
		DC.B    $07, $77, $77, $00
		DC.B    $00, $00, $00, $00
charselect4:
		DC.B    $77, $77, $70, $00;E
		DC.B    $77, $70, $00, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $77, $70, $00
		DC.B    $88, $00, $80, $00
		DC.B    $77, $70, $00, $00
		DC.B    $77, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $07, $77, $70, $00;C
		DC.B    $77, $70, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $07, $77, $00
		DC.B    $88, $00, $00, $00
		DC.B    $77, $70, $77, $00
		DC.B    $07, $77, $70, $00
		DC.B    $00, $00, $00, $00

		DC.B    $77, $77, $77, $70 ;T
		DC.B    $77, $77, $77, $70
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $88, $80, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $77, $70, $00
		DC.B    $00, $00, $00, $00

robotidle:	
		DC.B	$00,$00,$00,$01		;1
		DC.B	$00,$00,$00,$14
		DC.B	$00,$00,$01,$45
		DC.B	$00,$00,$01,$45
		DC.B	$00,$00,$00,$14
		DC.B	$01,$10,$00,$01
		DC.B	$13,$21,$00,$12
		DC.B	$01,$32,$11,$23


		DC.B	$01,$32,$11,$00		;2
		DC.B	$13,$21,$00,$10
		DC.B	$01,$10,$00,$01
		DC.B	$00,$00,$00,$01
		DC.B	$00,$00,$00,$13
		DC.B	$00,$00,$01,$23
		DC.B	$00,$00,$01,$32				
		DC.B	$00,$00,$13,$12

		DC.B	$00,$01,$31,$31		;3
		DC.B	$00,$01,$13,$10
		DC.B	$00,$13,$21,$00
		DC.B	$01,$23,$23,$10
		DC.B	$01,$32,$32,$10
		DC.B	$00,$12,$31,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$01,$10,$00

		DC.B	$00,$12,$31,$00		;4
		DC.B	$01,$32,$32,$10
		DC.B	$01,$23,$23,$10
		DC.B	$00,$13,$21,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$13,$31,$00
		DC.B	$01,$31,$13,$10

		DC.B	$10,$10,$00,$00		;5
		DC.B	$31,$10,$00,$00
		DC.B	$23,$10,$00,$00
		DC.B	$23,$10,$00,$00
		DC.B	$31,$00,$00,$00
		DC.B	$10,$00,$01,$10
		DC.B	$31,$00,$12,$31
		DC.B	$23,$11,$23,$10

		DC.B	$00,$11,$23,$10		;6
		DC.B	$01,$00,$12,$31
		DC.B	$10,$00,$01,$10
		DC.B	$10,$00,$00,$00
		DC.B	$31,$00,$00,$00
		DC.B	$32,$10,$00,$00
		DC.B	$23,$10,$00,$00
		DC.B	$21,$31,$00,$00

		DC.B	$13,$13,$10,$00		;7
		DC.B	$01,$31,$10,$00
		DC.B	$00,$12,$31,$00
		DC.B	$01,$32,$32,$10
		DC.B	$01,$23,$23,$10
		DC.B	$00,$13,$21,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$01,$10,$00

		DC.B	$00,$13,$21,$00		;8
		DC.B	$01,$23,$23,$10
		DC.B	$01,$32,$32,$10
		DC.B	$00,$12,$31,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$01,$10,$00
		DC.B	$00,$13,$31,$00
		DC.B	$01,$31,$13,$10

;----------------------------------------------------------
;palettes
;----------------------------------------------------------
PALETTE1:	DC.W	$0000,$0A00,$0E00,$00AE
		DC.W	$006A,$00A0,$00E0,$0008	
		DC.W	$000E,$000C,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000

PALETTE2:	DC.W	$0000,$0000,$0000,$0000	
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000

PALETTE3:	DC.W	$0000,$0000,$0000,$0000	
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000

PALETTE4:	DC.W	$0000,$0000,$0000,$0000	
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000
		DC.W	$0000,$0000,$0000,$0000

;----------------------------------------------------------
;
;----------------------------------------------------------
