require "player"
require "board"
require "solver"

io.stdout:setvbuf("no")

function love.load( )
	player.row = board.map.startRow
	player.col = board.map.startCol

	player.x = board.gridSize.X * player.col
	player.y = board.gridSize.Y * player.row	
end

function draw_hud( )
	-- Top
	love.graphics.setColor( 255, 255, 255 )
	scoreString = "Score: "..player.score.."\nMoves: "..player.moves.."\tShuffles: "..player.shuffles
	love.graphics.print( scoreString, 0, 0 )

	debugString = "-=-= DEBUG =-=- \nRow:"..player.row.."\nCol:"..player.col.."\n\nMap Rows:"..board.map.rows.."\nMap Cols:"..board.map.cols
	love.graphics.print( debugString, 900, 150 )

	debugString = "x: left, top, right \ny: back, top, front"
	love.graphics.print( debugString, 900, 0 )

	love.graphics.print( "Press 'R' to generate a new board\nPress 'S' to Shuffle the board\nPress 'C' to Shuffle the cube", 800, 300 )

	-- Draw a splayed out cube
	-- back
	side = player.cube.back
	love.graphics.setColor(
		player.sides[side].color.R,
		player.sides[side].color.G,
		player.sides[side].color.B,
		player.sides[side].color.A
	)
	love.graphics.rectangle( "fill", 928, 32, 32, 32 )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( side, 928, 32 )

	-- top
	side = player.cube.top
	love.graphics.setColor(
		player.sides[side].color.R,
		player.sides[side].color.G,
		player.sides[side].color.B,
		player.sides[side].color.A
	)	
	love.graphics.rectangle( "fill", 928, 64, 32, 32 )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( side, 928, 64 )

	-- front
	side = player.cube.front
	love.graphics.setColor(
		player.sides[side].color.R,
		player.sides[side].color.G,
		player.sides[side].color.B,
		player.sides[side].color.A
	)
	love.graphics.rectangle( "fill", 928, 96, 32, 32 )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( side, 928, 96 )

	-- left
	side = player.cube.leftSide
	love.graphics.setColor(
		player.sides[side].color.R,
		player.sides[side].color.G,
		player.sides[side].color.B,
		player.sides[side].color.A
	)
	love.graphics.rectangle( "fill", 896, 64, 32, 32 )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( side, 896, 64 )

	-- right
	side = player.cube.rightSide
	love.graphics.setColor(
		player.sides[side].color.R,
		player.sides[side].color.G,
		player.sides[side].color.B,
		player.sides[side].color.A
	)
	love.graphics.rectangle( "fill", 960, 64, 32, 32 )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( side, 960, 64 )
end

function draw_board( )
	for i = 1, map.rows do 
		ypos = (i * board.gridSize.Y) + board.gridSpace.Y
		for j = 1, map.cols do
			xpos = (j * board.gridSize.X) + board.gridSpace.X
			if board.map.matrix[i][j] ~= BOARD_IMPASSABLE then
				love.graphics.setColor(
					player.sides[board.map.matrix[i][j]].color.R,
					player.sides[board.map.matrix[i][j]].color.G,
					player.sides[board.map.matrix[i][j]].color.B,
					player.sides[board.map.matrix[i][j]].color.A
				)
				
				if board.map.matrix[i][j] ~= BOARD_GOAL then
					love.graphics.rectangle( "line", xpos , ypos, board.gridSize.X, board.gridSize.Y )
					love.graphics.setColor( 255, 255, 255 )
					love.graphics.print( board.map.matrix[i][j], xpos + 12, ypos + 10 )
				else 
					love.graphics.rectangle( "fill", xpos , ypos, board.gridSize.X, board.gridSize.Y )
					love.graphics.setColor( 0, 0, 0 )
					love.graphics.print( "GOAL", xpos, ypos + 10 )
				end
			end
		end
	end
end

function love.draw( )
	draw_hud( )
	draw_board( )

	-- Player Cube Color
	love.graphics.setColor(
		player.sides[player.cube.bottom].color.R,
		player.sides[player.cube.bottom].color.G,
		player.sides[player.cube.bottom].color.B,
		player.sides[player.cube.bottom].color.A
	)
	love.graphics.rectangle( "fill", player.x, player.y, board.gridSize.X, board.gridSize.Y )

	--[[ Removed because it was confusing.
	-- Side printied on cube
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.printf( player.cube.top, player.x, player.y + 8, 32, 'center' )]]
end 

function love.keypressed( key )
	if key == "up" then 
		playerMoveUp( )
	end

	if key == "down" then
		playerMoveDown( )
	end

	if key == "left" then
		playerMoveLeft( )
	end

	if key == "right" then
		playerMoveRight( )
	end

	if key == 'r' then 
		board.map = nil
		board.map = create_board( )

		player.row = board.map.startRow
		player.col = board.map.startCol

		player.x = board.gridSize.X * player.col
		player.y = board.gridSize.Y * player.row

		player.shuffles = 3
		player.score = 0
	end

	if key == 's' then
		if player.shuffles - 1 > -1 then 
			player.shuffles = player.shuffles - 1;
			reshuffle_board( )
		else
			player.sides[BOARD_IMPASSABLE].sound:play( )
		end
	end

	if key == 'c' then 
		shuffleCube( )
	end
end

function love.quit( )
	-- Bye!
end
