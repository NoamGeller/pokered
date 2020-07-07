SSAnne2FRooms_Script:
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, SSAnne9TrainerHeader0
	ld de, SSAnne2FRooms_ScriptPointers
	ld a, [wSSAnne2FRoomsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnne2FRoomsCurScript], a
	ret

SSAnne2FRooms_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SSAnne2FRooms_TextPointers:
	dw SSAnne9Text1
	dw SSAnne9Text2
	dw SSAnne9Text3
	dw SSAnne9Text4
	dw SSAnne9Text5
	dw PickUpItemText
	dw SSAnne9Text7
	dw SSAnne9Text8
	dw PickUpItemText
	dw SSAnne9Text10
	dw SSAnne9Text11
	dw SSAnne9Text12
	dw SSAnne9Text13

SSAnne9TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_9_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_9_TRAINER_0
	dw SSAnne9BattleText1 ; TextBeforeBattle
	dw SSAnne9AfterBattleText1 ; TextAfterBattle
	dw SSAnne9EndBattleText1 ; TextEndBattle
	dw SSAnne9EndBattleText1 ; TextEndBattle

SSAnne9TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_9_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_9_TRAINER_1
	dw SSAnne9BattleText2 ; TextBeforeBattle
	dw SSAnne9AfterBattleText2 ; TextAfterBattle
	dw SSAnne9EndBattleText2 ; TextEndBattle
	dw SSAnne9EndBattleText2 ; TextEndBattle

SSAnne9TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_9_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_9_TRAINER_2
	dw SSAnne9BattleText3 ; TextBeforeBattle
	dw SSAnne9AfterBattleText3 ; TextAfterBattle
	dw SSAnne9EndBattleText3 ; TextEndBattle
	dw SSAnne9EndBattleText3 ; TextEndBattle

SSAnne9TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_9_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_9_TRAINER_3
	dw SSAnne9BattleText4 ; TextBeforeBattle
	dw SSAnne9AfterBattleText4 ; TextAfterBattle
	dw SSAnne9EndBattleText4 ; TextEndBattle
	dw SSAnne9EndBattleText4 ; TextEndBattle

	db $ff

SSAnne9Text1:
	text_asm
	ld hl, SSAnne9TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text2:
	text_asm
	ld hl, SSAnne9TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text3:
	text_asm
	ld hl, SSAnne9TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text4:
	text_asm
	ld hl, SSAnne9TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text5:
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, SSAnne9Text_61bf2
	call PrintText
	call LoadScreenTilesFromBuffer1
	ld a, SNORLAX
	call DisplayPokedex
	jp TextScriptEnd

SSAnne9Text_61bf2:
	text_far _SSAnne9Text_61bf2
	text_end

SSAnne9Text7:
	text_asm
	ld hl, SSAnne9Text_61c01
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c01:
	text_far _SSAnne9Text_61c01
	text_end

SSAnne9Text8:
	text_asm
	ld hl, SSAnne9Text_61c10
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c10:
	text_far _SSAnne9Text_61c10
	text_end

SSAnne9Text10:
	text_asm
	ld hl, SSAnne9Text_61c1f
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c1f:
	text_far _SSAnne9Text_61c1f
	text_end

SSAnne9Text11:
	text_asm
	ld hl, SSAnne9Text_61c2e
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c2e:
	text_far _SSAnne9Text_61c2e
	text_end

SSAnne9Text12:
	text_asm
	ld hl, SSAnne9Text_61c3d
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c3d:
	text_far _SSAnne9Text_61c3d
	text_end

SSAnne9Text13:
	text_asm
	ld hl, SSAnne9Text_61c4c
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c4c:
	text_far _SSAnne9Text_61c4c
	text_end

SSAnne9BattleText1:
	text_far _SSAnne9BattleText1
	text_end

SSAnne9EndBattleText1:
	text_far _SSAnne9EndBattleText1
	text_end

SSAnne9AfterBattleText1:
	text_far _SSAnne9AfterBattleText1
	text_end

SSAnne9BattleText2:
	text_far _SSAnne9BattleText2
	text_end

SSAnne9EndBattleText2:
	text_far _SSAnne9EndBattleText2
	text_end

SSAnne9AfterBattleText2:
	text_far _SSAnne9AfterBattleText2
	text_end

SSAnne9BattleText3:
	text_far _SSAnne9BattleText3
	text_end

SSAnne9EndBattleText3:
	text_far _SSAnne9EndBattleText3
	text_end

SSAnne9AfterBattleText3:
	text_far _SSAnne9AfterBattleText3
	text_end

SSAnne9BattleText4:
	text_far _SSAnne9BattleText4
	text_end

SSAnne9EndBattleText4:
	text_far _SSAnne9EndBattleText4
	text_end

SSAnne9AfterBattleText4:
	text_far _SSAnne9AfterBattleText4
	text_end
