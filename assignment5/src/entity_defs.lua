--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        MAX_HEALTH = 6,
        animations = {
            ['walk-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.155,
                looping = true,
                texture = 'character-walk'
            },
            ['walk-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                looping = true,
                texture = 'character-walk'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                looping = true,
                texture = 'character-walk'
            },
            ['walk-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                looping = true,
                texture = 'character-walk'
            },
            ['idle-left'] = {
                frames = {13},
                texture = 'character-walk'
            },
            ['idle-right'] = {
                frames = {5},
                texture = 'character-walk'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'character-walk'
            },
            ['idle-up'] = {
                frames = {9},
                texture = 'character-walk'
            },
            ['sword-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-swing-sword'
            },
            ['sword-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-swing-sword'
            },
            ['sword-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-swing-sword'
            },
            ['sword-up'] = {
                frames = {7, 8, 9},
                interval = 0.05,
                looping = false,
                texture = 'character-swing-sword'
            },
            ['catch-left'] = {
                frames = {10, 11, 12},
                interval = 0.5,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['catch-right'] = {
                frames = {4, 5, 6},
                interval = 0.5,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['catch-down'] = {
                frames = {1, 2, 3},
                interval = 0.5,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['catch-up'] = {
                frames = {7, 8, 9},
                interval = 0.5,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['walk-pot-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.20,
                looping = true,
                texture = 'character-walk-pot'
            },
            ['walk-pot-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.20,
                looping = true,
                texture = 'character-walk-pot'
            },
            ['walk-pot-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.20,
                looping = true,
                texture = 'character-walk-pot'
            },
            ['walk-pot-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.20,
                looping = true,
                texture = 'character-walk-pot'
            },
            ['idle-pot-left'] = {
                frames = {12},
                texture = 'character-lift-pot'
            },
            ['idle-pot-right'] = {
                frames = {6},
                texture = 'character-lift-pot'
            },
            ['idle-pot-down'] = {
                frames = {3},
                texture = 'character-lift-pot'
            },
            ['idle-pot-up'] = {
                frames = {9},
                texture = 'character-lift-pot'
            },
            ['throw-left'] = {
                frames = {12, 11},
                interval = 0.05,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['throw-right'] = {
                frames = {6, 5},
                interval = 0.05,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['throw-down'] = {
                frames = {3, 2},
                interval = 0.05,
                looping = false,
                texture = 'character-lift-pot'
            },
            ['throw-up'] = {
                frames = {9, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-lift-pot'
            }

        }
    },
    ['skeleton'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {22, 23, 24, 23},
                looping = true,
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {34, 35, 36, 35},
                looping = true,
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {10, 11, 12, 11},
                looping = true,
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {46, 47, 48, 47},
                looping = true,
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {23}
            },
            ['idle-right'] = {
                frames = {35}
            },
            ['idle-down'] = {
                frames = {11}
            },
            ['idle-up'] = {
                frames = {47}
            },
            ['die-left'] = {
                frames = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
                interval = 0.1,
                looping = false,
                texture = "die_skeleton"
            },
            ['die-right'] = {
                frames = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
                interval = 0.1,
                looping = false,
                texture = "die_skeleton"
            },
            ['die-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                looping = false,
                texture = "die_skeleton"
            },
            ['die-up'] = {
                frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
                interval = 0.1,
                looping = false,
                texture = "die_skeleton"
            }
        }
    },
    ['slime'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {61, 62, 63, 62},
                looping = true,
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {73, 74, 75, 74},
                looping = true,
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {49, 50, 51, 50},
                looping = true,
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {86, 86, 87, 86},
                looping = true,
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {62}
            },
            ['idle-right'] = {
                frames = {74}
            },
            ['idle-down'] = {
                frames = {50}
            },
            ['idle-up'] = {
                frames = {86}
            },
            ['die-left'] = {
                frames = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
                interval = 0.1,
                looping = false,
                texture = "die_slime"
            },
            ['die-right'] = {
                frames = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
                interval = 0.1,
                looping = false,
                texture = "die_slime"
            },
            ['die-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                looping = false,
                texture = "die_slime"
            },
            ['die-up'] = {
                frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
                interval = 0.1,
                looping = false,
                texture = "die_slime"
            }
        }
    },
    ['bat'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {64, 65, 66, 65},
                looping = true,
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {76, 77, 78, 77},
                looping = true,
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {52, 53, 54, 53},
                looping = true,
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {88, 89, 90, 89},
                looping = true,
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {64, 65, 66, 65},
                looping = true,
                interval = 0.2
            },
            ['idle-right'] = {
                frames = {76, 77, 78, 77},
                looping = true,
                interval = 0.2
            },
            ['idle-down'] = {
                frames = {52, 53, 54, 53},
                looping = true,
                interval = 0.2
            },
            ['idle-up'] = {
                frames = {88, 89, 90, 89},
                looping = true,
                interval = 0.2
            },
            ['die-left'] = {
                frames = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
                interval = 0.1,
                looping = false,
                texture = "die_bat"
            },
            ['die-right'] = {
                frames = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
                interval = 0.1,
                looping = false,
                texture = "die_bat"
            },
            ['die-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                looping = false,
                texture = "die_bat"
            },
            ['die-up'] = {
                frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
                interval = 0.1,
                looping = false,
                texture = "die_bat"
            }
        }
    },
    ['ghost'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {67, 68, 69, 68},
                looping = true,
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {79, 80, 81, 80},
                looping = true,
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {55, 56, 57, 56},
                looping = true,
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {91, 92, 93, 92},
                looping = true,
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {68}
            },
            ['idle-right'] = {
                frames = {80}
            },
            ['idle-down'] = {
                frames = {56}
            },
            ['idle-up'] = {
                frames = {92}
            },
            ['die-left'] = {
                frames = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
                interval = 0.1,
                looping = false,
                texture = "die_ghost"
            },
            ['die-right'] = {
                frames = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
                interval = 0.1,
                looping = false,
                texture = "die_ghost"
            },
            ['die-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                looping = false,
                texture = "die_ghost"
            },
            ['die-up'] = {
                frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
                interval = 0.1,
                looping = false,
                texture = "die_ghost"
            }
        }
    },
    ['spider'] = {
        texture = 'entities',
        animations = {
            ['walk-left'] = {
                frames = {70, 71, 72, 71},
                looping = true,
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {82, 83, 84, 83},
                looping = true,
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {58, 59, 60, 59},
                looping = true,
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {94, 95, 96, 95},
                looping = true,
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {71}
            },
            ['idle-right'] = {
                frames = {83}
            },
            ['idle-down'] = {
                frames = {59}
            },
            ['idle-up'] = {
                frames = {95}
            },
            ['die-left'] = {
                frames = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
                interval = 0.1,
                looping = false,
                texture = "die_spider"
            },
            ['die-right'] = {
                frames = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
                interval = 0.1,
                looping = false,
                texture = "die_spider"
            },
            ['die-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                looping = false,
                texture = "die_spider"
            },
            ['die-up'] = {
                frames = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
                interval = 0.1,
                looping = false,
                texture = "die_spider"
        }
    }
    }
}