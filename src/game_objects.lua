GAME_OBJECT_DEFS = {
    ['switch-end'] = {
        type = 'switch',
        texture = 'switches',
        frame = 3,
        width = 8,
        height = 8,
        solid = false,
        defaultState = 'color0',
        states = {
            ['color0'] = {
                frame = 3
            },
            ['color1'] = {
                frame = 4
            },
            ['color2'] = {
                frame = 2
            },
            ['color3'] = {
                frame = 1
            }
        }
    },
    ['switch-start'] = {
        type = 'switch',
        texture = 'switches',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'pressed',
        states = {
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpicked',
        states = {
            ['unpicked'] = {
                frame = 5
            }
        }
    }, 
    ['wall'] = {
        type = 'wall',
        texture = 'wall-side',
        frame = 1,
        width = 16,
        height = 16, 
        solid = true,
        defaultState = 'obstacle',
        states = {
            ['obstacle'] = {
                frame = 1
            }
        }
    }
}