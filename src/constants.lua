VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16

--
-- entity constants
--
PLAYER_WALK_SPEED = 60

-- 
-- player id on the spritesheet
--
PLAYERS = {3, 4, 5}

--
-- time limit (in seconds)
--
TIME_LIMIT = 180

--
-- bonus scores
-- 
BONUS = 1
BONUS_HEART = 10

--
-- level design
-- reg: self.map\[([1-9])\]\[([1-9])\]\.id = 'wall'
-- replace: {$1, $2},
-- 
MAP_WALLS = { -- {y, x}
    { -- level 1        
        {3, 7},
        {3, 8},
        {4, 4},
        {4, 5},
        {5, 4},
        {5, 7},
        {7, 3},
        {7, 4},
        {7, 5},
        {7, 7},
        {7, 8},
        {9, 2},
    },
    { -- level 2        
        {3, 3},
        {3, 4},
        {3, 5},
        {3, 6},
        {3, 9},
        {4, 9},
        {5, 9},
        {6, 6},
        {6, 7},
        {6, 8},
        {6, 9},
        {7, 3},
        {7, 4},
        {8, 5},
        {8, 6},
        {8, 7},
        {8, 8},
    }
}

MAP_HEARTS = {
    { -- level 1  
        {2, 9},
        {6, 4}, 
        {6, 7}
    },
    { -- level 2          
        {2, 2}, 
        {4, 4}, 
        {9, 2}
    }
}

MAP_START = {
    {8, 3}, 
    {8, 3}
}

MAP_END = {
    {4, 6},
    {6, 4}
}