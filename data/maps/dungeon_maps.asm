; GetBattleTransitionID_IsDungeonMap checks if wCurMap
; is equal to one of these maps
DungeonMaps1:
	db VIRIDIAN_FOREST
	db ROCK_TUNNEL_1F
	db SEAFOAM_ISLANDS_1F
	db ROCK_TUNNEL_B1F
	db $FF

; GetBattleTransitionID_IsDungeonMap checks if wCurMap
; is in between or equal to each pair of maps
DungeonMaps2:
	; all MT_MOON maps
	db MT_MOON_1F
	db MT_MOON_B2F

	; all SS_ANNE maps, VICTORY_ROAD_1F, LANCES_ROOM, and HALL_OF_FAME
	db SS_ANNE_1F
	db HALL_OF_FAME

	; all POKEMON_TOWER maps and Lavender Town buildings
	db LAVENDER_POKECENTER
	db LAVENDER_CUBONE_HOUSE

	; SILPH_CO_[2-8]F, POKEMON_MANSION[2F-B1F], SAFARI_ZONE, and
	; CERULEAN_CAVE maps, except for SILPH_CO_1F
	db SILPH_CO_2F
	db CERULEAN_CAVE_1F
	db $FF
