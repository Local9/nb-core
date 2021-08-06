com.lua = {}
com.lua.utils = {}
com.lua.Threads = {}
com.lua.utils.Encryption = {}
com.lua.utils.Colour = {}
com.lua.utils.Csv = {}
com.lua.utils.Math = {}
com.lua.utils.Remote = {}
com.lua.utils.SpawnManager = {}
com.lua.utils.Text = {}

com.lua.utils.Colour.HUD_COLOURS = {}
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PURE_WHITE'] = 0
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_WHITE'] = 1
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BLACK'] = 2
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREY'] = 3
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREYLIGHT'] = 4
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREYDARK'] = 5
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_RED'] = 6
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_REDLIGHT'] = 7
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_REDDARK'] = 8
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BLUE'] = 9
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BLUELIGHT'] = 10
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BLUEDARK'] = 11
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_YELLOW'] = 12
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_YELLOWLIGHT'] = 13
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_YELLOWDARK'] = 14
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_ORANGE'] = 15
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_ORANGELIGHT'] = 16
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_ORANGEDARK'] = 17
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREEN'] = 18
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREENLIGHT'] = 19
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GREENDARK'] = 20
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PURPLE'] = 21
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PURPLELIGHT'] = 22
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PURPLEDARK'] = 23
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PINK'] = 24
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_RADAR_HEALTH'] = 25
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_RADAR_ARMOUR'] = 26
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_RADAR_DAMAGE'] = 27
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER1'] = 28
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER2'] = 29
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER3'] = 30
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER4'] = 31
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER5'] = 32
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER6'] = 33
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER7'] = 34
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER8'] = 35
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER9'] = 36
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER10'] = 37
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER11'] = 38
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER12'] = 39
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER13'] = 40
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER14'] = 41
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER15'] = 42
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER16'] = 43
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER17'] = 44
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER18'] = 45
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER19'] = 46
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER20'] = 47
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER21'] = 48
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER22'] = 49
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER23'] = 50
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER24'] = 51
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER25'] = 52
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER26'] = 53
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER27'] = 54
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER28'] = 55
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER29'] = 56
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER30'] = 57
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER31'] = 58
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER32'] = 59
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SIMPLEBLIP_DEFAULT'] = 60
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_BLUE'] = 61
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_GREY_LIGHT'] = 62
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_BLUE_EXTRA_DARK'] = 63
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_YELLOW'] = 64
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_YELLOW_DARK'] = 65
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_GREEN'] = 66
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_GREY'] = 67
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_GREY_DARK'] = 68
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_HIGHLIGHT'] = 69
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_STANDARD'] = 70
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_DIMMED'] = 71
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MENU_EXTRA_DIMMED'] = 72
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BRIEF_TITLE'] = 73
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MID_GREY_MP'] = 74
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER1_DARK'] = 75
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER2_DARK'] = 76
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER3_DARK'] = 77
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER4_DARK'] = 78
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER5_DARK'] = 79
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER6_DARK'] = 80
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER7_DARK'] = 81
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER8_DARK'] = 82
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER9_DARK'] = 83
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER10_DARK'] = 84
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER11_DARK'] = 85
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER12_DARK'] = 86
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER13_DARK'] = 87
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER14_DARK'] = 88
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER15_DARK'] = 89
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER16_DARK'] = 90
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER17_DARK'] = 91
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER18_DARK'] = 92
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER19_DARK'] = 93
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER20_DARK'] = 94
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER21_DARK'] = 95
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER22_DARK'] = 96
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER23_DARK'] = 97
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER24_DARK'] = 98
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER25_DARK'] = 99
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER26_DARK'] = 100
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER27_DARK'] = 101
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER28_DARK'] = 102
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER29_DARK'] = 103
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER30_DARK'] = 104
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER31_DARK'] = 105
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NET_PLAYER32_DARK'] = 106
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_BRONZE'] = 107
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SILVER'] = 108
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLD'] = 109
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PLATINUM'] = 110
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GANG1'] = 111
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GANG2'] = 112
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GANG3'] = 113
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GANG4'] = 114
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SAME_CREW'] = 115
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FREEMODE'] = 116
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PAUSE_BG'] = 117
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FRIENDLY'] = 118
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_ENEMY'] = 119
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_LOCATION'] = 120
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PICKUP'] = 121
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PAUSE_SINGLEPLAYER'] = 122
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FREEMODE_DARK'] = 123
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_INACTIVE_MISSION'] = 124
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DAMAGE'] = 125
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PINKLIGHT'] = 126
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PM_MITEM_HIGHLIGHT'] = 127
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SCRIPT_VARIABLE'] = 128
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_YOGA'] = 129
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TENNIS'] = 130
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLF'] = 131
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SHOOTING_RANGE'] = 132
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FLIGHT_SCHOOL'] = 133
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NORTH_BLUE'] = 134
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SOCIAL_CLUB'] = 135
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PLATFORM_BLUE'] = 136
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PLATFORM_GREEN'] = 137
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PLATFORM_GREY'] = 138
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FACEBOOK_BLUE'] = 139
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_INGAME_BG'] = 140
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DARTS'] = 141
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_WAYPOINT'] = 142
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MICHAEL'] = 143
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FRANKLIN'] = 144
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TREVOR'] = 145
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLF_P1'] = 146
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLF_P2'] = 147
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLF_P3'] = 148
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GOLF_P4'] = 149
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_WAYPOINTLIGHT'] = 150
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_WAYPOINTDARK'] = 151
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PANEL_LIGHT'] = 152
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_MICHAEL_DARK'] = 153
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_FRANKLIN_DARK'] = 154
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TREVOR_DARK'] = 155
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_OBJECTIVE_ROUTE'] = 156
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PAUSEMAP_TINT'] = 157
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PAUSE_DESELECT'] = 158
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PM_WEAPONS_PURCHASABLE'] = 159
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PM_WEAPONS_LOCKED'] = 160
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_END_SCREEN_BG'] = 161
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CHOP'] = 162
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_PAUSEMAP_TINT_HALF'] = 163
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_NORTH_BLUE_OFFICIAL'] = 164
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SCRIPT_VARIABLE_2'] = 165
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_H'] = 166
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_HDARK'] = 167
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_T'] = 168
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TDARK'] = 169
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_HSHARD'] = 170
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CONTROLLER_MICHAEL'] = 171
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CONTROLLER_FRANKLIN'] = 172
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CONTROLLER_TREVOR'] = 173
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CONTROLLER_CHOP'] = 174
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_VIDEO'] = 175
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_AUDIO'] = 176
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_TEXT'] = 177
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_HB_BLUE'] = 178
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_HB_YELLOW'] = 179
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_SCORE'] = 180
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_AUDIO_FADEOUT'] = 181
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_TEXT_FADEOUT'] = 182
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_SCORE_FADEOUT'] = 183
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_HEIST_BACKGROUND'] = 184
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_AMBIENT'] = 185
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_VIDEO_EDITOR_AMBIENT_FADEOUT'] = 186
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_GB'] = 187
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G'] = 188
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_B'] = 189
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_LOW_FLOW'] = 190
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_LOW_FLOW_DARK'] = 191
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G1'] = 192
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G2'] = 193
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G3'] = 194
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G4'] = 195
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G5'] = 196
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G6'] = 197
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G7'] = 198
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G8'] = 199
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G9'] = 200
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G10'] = 201
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G11'] = 202
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G12'] = 203
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G13'] = 204
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G14'] = 205
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_G15'] = 206
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_ADVERSARY'] = 207
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_RED'] = 208
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_YELLOW'] = 209
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_GREEN'] = 210
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_CYAN'] = 211
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_BLUE'] = 212
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_DEGEN_MAGENTA'] = 213
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_STUNT_1'] = 214
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_STUNT_2'] = 215
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SPECIAL_RACE_SERIES'] = 216
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_SPECIAL_RACE_SERIES_DARK'] = 217
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CS'] = 218
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_CS_DARK'] = 219
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TECH_GREEN'] = 220
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TECH_GREEN_DARK'] = 221
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TECH_RED'] = 222
com.lua.utils.Colour.HUD_COLOURS['HUD_COLOUR_TECH_GREEN_VERY_DARK'] = 223