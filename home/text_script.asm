; this function is used to display sign messages, sprite dialog, etc.
; INPUT: [hSpriteIndexOrTextID] = sprite ID or text ID
DisplayTextID::
	ld a, [hLoadedROMBank]
	push af
	callba DisplayTextIDInit ; initialization
	ld hl, wTextPredefFlag
	bit 0, [hl]
	res 0, [hl]
	jr nz, .skipSwitchToMapBank
	ld a, [wCurMap]
	call SwitchToMapRomBank
.skipSwitchToMapBank
	ld a, 30 ; half a second
	ld [hFrameCounter], a ; used as joypad poll timer
	ld hl, wMapTextPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = map text pointer
	ld d, $00
	ld a, [hSpriteIndexOrTextID] ; text ID
	ld [wSpriteIndex], a

	dict TEXT_START_MENU,       DisplayStartMenu
	dict TEXT_SAFARI_GAME_OVER, DisplaySafariGameOverText
	dict TEXT_MON_FAINTED,      DisplayPokemonFaintedText
	dict TEXT_BLACKED_OUT,      DisplayPlayerBlackedOutText
	dict TEXT_REPEL_WORE_OFF,   DisplayRepelWoreOffText

	ld a, [wNumSprites]
	ld e, a
	ld a, [hSpriteIndexOrTextID] ; sprite ID
	cp e
	jr z, .spriteHandling
	jr nc, .skipSpriteHandling
.spriteHandling
; get the text ID of the sprite
	push hl
	push de
	push bc
	callba UpdateSpriteFacingOffsetAndDelayMovement ; update the graphics of the sprite the player is talking to (to face the right direction)
	pop bc
	pop de
	ld hl, wMapSpriteData ; NPC text entries
	ld a, [hSpriteIndexOrTextID]
	dec a
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc hl
	ld a, [hl] ; a = text ID of the sprite
	pop hl
.skipSpriteHandling
; look up the address of the text in the map's text entries
	dec a
	ld e, a
	sla e
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = address of the text
	ld a, [hl] ; a = first byte of text

; check first byte of text for special cases

dict2: MACRO
	cp \1
	jr nz, .not\@
	\2
	jr AfterDisplayingTextID
.not\@
ENDM

	dict  TX_SCRIPT_MART,                    DisplayPokemartDialogue
	dict  TX_SCRIPT_POKECENTER_NURSE,        DisplayPokemonCenterDialogue
	dict  TX_SCRIPT_PLAYERS_PC,              TextScript_ItemStoragePC
	dict  TX_SCRIPT_BILLS_PC,                TextScript_BillsPC
	dict  TX_SCRIPT_POKECENTER_PC,           TextScript_PokemonCenterPC
	dict2 TX_SCRIPT_VENDING_MACHINE,         callba VendingMachineMenu
	dict  TX_SCRIPT_PRIZE_VENDOR,            TextScript_GameCornerPrizeMenu
	dict2 TX_SCRIPT_CABLE_CLUB_RECEPTIONIST, callab CableClubNPC

	call PrintText_NoCreatingTextBox ; display the text
	ld a, [wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz, HoldTextDisplayOpen

AfterDisplayingTextID::
	ld a, [wEnteringCableClub]
	and a
	jr nz, HoldTextDisplayOpen
	call WaitForTextScrollButtonPress ; wait for a button press after displaying all the text

; loop to hold the dialogue box open as long as the player keeps holding down the A button
HoldTextDisplayOpen::
	call Joypad
	ld a, [hJoyHeld]
	bit 0, a ; is the A button being pressed?
	jr nz, HoldTextDisplayOpen

CloseTextDisplay::
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld a, $90
	ld [hWY], a ; move the window off the screen
	call DelayFrame
	call LoadGBPal
	xor a
	ld [hAutoBGTransferEnabled], a ; disable continuous WRAM to VRAM transfer each V-blank
; loop to make sprites face the directions they originally faced before the dialogue
	ld hl, wSprite01StateData2 + 9 ; should be wSprite01StateData1FacingDirection?
	ld c, $0f
	ld de, $10
.restoreSpriteFacingDirectionLoop
	ld a, [hl]
	dec h
	ld [hl], a
	inc h
	add hl, de
	dec c
	jr nz, .restoreSpriteFacingDirectionLoop
	ld a, BANK(InitMapSprites)
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call InitMapSprites ; reload sprite tile pattern data (since it was partially overwritten by text tile patterns)
	ld hl, wFontLoaded
	res 0, [hl]
	ld a, [wd732]
	bit 3, a ; used fly warp
	call z, LoadPlayerSpriteGraphics
	call LoadCurrentMapView
	pop af
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	jp UpdateSprites

DisplayPokemartDialogue::
	push hl
	ld hl, PokemartGreetingText
	call PrintText
	pop hl
	inc hl
	call LoadItemList
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	ld a, [hLoadedROMBank]
	push af
	ld a, BANK(DisplayPokemartDialogue_)
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call DisplayPokemartDialogue_
	pop af
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	jp AfterDisplayingTextID

PokemartGreetingText::
	text_far _PokemartGreetingText
	text_end

LoadItemList::
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld a, h
	ld [wItemListPointer], a
	ld a, l
	ld [wItemListPointer + 1], a
	ld de, wItemList
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .loop
	ret

DisplayPokemonCenterDialogue::
; zeroing these doesn't appear to serve any purpose
	xor a
	ld [hItemPrice], a
	ld [hItemPrice + 1], a
	ld [hItemPrice + 2], a

	inc hl
	ld a, [hLoadedROMBank]
	push af
	ld a, BANK(DisplayPokemonCenterDialogue_)
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call DisplayPokemonCenterDialogue_
	pop af
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
	jp AfterDisplayingTextID

DisplaySafariGameOverText::
	callab PrintSafariGameOverText
	jp AfterDisplayingTextID

DisplayPokemonFaintedText::
	ld hl, PokemonFaintedText
	call PrintText
	jp AfterDisplayingTextID

PokemonFaintedText::
	text_far _PokemonFaintedText
	text_end

DisplayPlayerBlackedOutText::
	ld hl, PlayerBlackedOutText
	call PrintText
	ld a, [wd732]
	res 5, a ; reset forced to use bike bit
	ld [wd732], a
	jp HoldTextDisplayOpen

PlayerBlackedOutText::
	text_far _PlayerBlackedOutText
	text_end

DisplayRepelWoreOffText::
	ld hl, RepelWoreOffText
	call PrintText
	jp AfterDisplayingTextID

RepelWoreOffText::
	text_far _RepelWoreOffText
	text_end
