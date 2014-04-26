PLAYER_MOVE_OUT_OF_BOUNDS = 1
PLAYER_MOVE_INVALID = 2

player = {
	x = 0,
	y = 0,
	row = 0, 
	col = 0,
	score = 0,
	moves = 0,
	shuffles = 3,
	cube = {
		top = 1, 
		front = 2, 
		bottom = 6, 
		back = 5, 
		leftSide = 4,
		rightSide = 3
	},
	sides = {
		{ 
			-- Side 1
			color = { R = 255, G = 0, B = 0, A = 255}, -- red
			sound = love.audio.newSource( "sound/1.wav", "static" )
		},
		{ 
			-- Side 2
			color = { R = 0, G = 0, B = 255, A = 255}, -- blue
			sound = love.audio.newSource( "sound/2.wav", "static" )
		},
		{ 
			-- Side 3
			color = { R = 0, G = 255, B = 0, A = 255}, -- green
			sound = love.audio.newSource( "sound/3.wav", "static" )
		},
		{ 
			-- Side 4
			color = { R = 255, G = 0, B = 255, A = 255}, -- magenta
			sound = love.audio.newSource( "sound/4.wav", "static" )
		},
		{ 
			-- Side 5
			color = { R = 0, G = 255, B = 255, A = 255}, -- cyan
			sound = love.audio.newSource( "sound/5.wav", "static" )
		},
		{ 
			-- Side 6
			color = { R = 255, G = 255, B = 0, A = 255}, -- yellow
			sound = love.audio.newSource( "sound/6.wav", "static" )
		},
		{ 
			-- Side 7 (impassible)
			color = { R = 255, G = 255, B = 255, A = 255}, -- white
			sound = love.audio.newSource( "sound/no_move.wav", "static" )
		},
		{ 
			-- Side 8 (Goal!)
			color = { R = 255, G = 255, B = 255, A = 255}, -- white
			sound = love.audio.newSource( "sound/goal.wav", "static" )
		}
	}
}

function cubeMoveLeft( )
	-- top, left, right, bottom will change
	old = player.cube.leftSide
	player.cube.leftSide = player.cube.top
	player.cube.top = player.cube.rightSide
	player.cube.rightSide = player.cube.bottom

	player.cube.bottom = old
end

function cubeMoveRight()
	-- top, left, right, bottom will change
	old = player.cube.rightSide
	player.cube.rightSide = player.cube.top
	player.cube.top = player.cube.leftSide
	player.cube.leftSide = player.cube.bottom

	player.cube.bottom = old
end

function cubeMoveUp()
	-- top, front, back, bottom will change
	old = player.cube.back
	player.cube.back = player.cube.top
	player.cube.top = player.cube.front
	player.cube.front = player.cube.bottom

	player.cube.bottom = old
end

function cubeMoveDown()
	--top, front, back, bottom will change
	old = player.cube.front
	player.cube.front = player.cube.top
	player.cube.top = player.cube.back
	player.cube.back = player.cube.bottom

	player.cube.bottom = old
end

function rotateCubeTo( side )
	if side ~= player.cube.bottom then
		if player.cube.top == side then
			cubeMoveUp()
			cubeMoveUp()
		elseif player.cube.leftSide == side  then
			cubeMoveLeft( )
		elseif player.cube.rightSide == side then
			cubeMoveRight( )
		elseif player.cube.front == side then
			cubeMoveDown( )
		elseif player.cube.back == side then
			cubeMoveUp( )
		else 
			-- BOOM
		end
	end
end

function shuffleCube( )
	maxIterations = 10
	minIterations = 1 

	for i = 1, math.random( minIterations, maxIterations ) do
		direction = math.random( 1, 4 )

		if direction == 1 then 
			cubeMoveUp( )
		elseif direction == 2 then 
			cubeMoveDown( )
		elseif direction == 3 then 
			cubeMoveLeft( )
		elseif direction == 4 then 
			cubeMoveRight( )
		else 
			-- ???
		end 
	end
end

function playerMoveUp( )
	if (player.row - 1) >= 1 then
		if player.cube.back == board.map.matrix[player.row - 1][player.col] then 
			if board.map.matrix[player.row - 1][player.col] ~= BOARD_IMPASSABLE then
				cubeMoveUp()
				player.moves = player.moves + 1

				player.y = player.y - board.gridSize.Y
				player.row = player.row - 1;

				player.sides[player.cube.bottom].sound:play()
			end
		end
	end
end

function playerMoveDown( )
	if (player.row + 1) <= board.map.rows then
		if player.cube.front == board.map.matrix[player.row + 1][player.col] then 
			if board.map.matrix[player.row + 1][player.col] ~= BOARD_IMPASSABLE then
				cubeMoveDown( )
				player.moves = player.moves + 1

				player.y = player.y + board.gridSize.Y
				player.row = player.row + 1;

				player.sides[player.cube.bottom].sound:play()
			end
		end
	end
end

function playerMoveLeft( )
	if (player.col - 1) >= 1 then
		if player.cube.leftSide == board.map.matrix[player.row][player.col - 1] then 
			if board.map.matrix[player.row][player.col - 1] ~= BOARD_IMPASSABLE then
				cubeMoveLeft( )
				player.moves = player.moves + 1

				player.x = player.x - board.gridSize.X
				player.col = player.col - 1;

				player.sides[player.cube.bottom].sound:play()
			end
		end
	end
end

function playerMoveRight( )
	if (player.col + 1) <= board.map.cols then
		if player.cube.rightSide == board.map.matrix[player.row][player.col + 1] then 
			if board.map.matrix[player.row][player.col + 1] ~=  BOARD_IMPASSABLE then
				cubeMoveRight( )
				player.moves = player.moves + 1

				player.x = player.x + board.gridSize.X
				player.col = player.col + 1;

				player.sides[player.cube.bottom].sound:play()
			end
		end
	end
end
