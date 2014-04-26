BOARD_IMPASSABLE = 7
BOARD_GOAL = 8

math.randomseed( os.time( ) )

function create_board( )
	maxCols = 22
	minCols = 8

	maxRows = 22
	minRows = 10

	map = {
		startRow = 0,
		startCol = 0,
		rows = 0,
		cols = 0,
		goal = { row = 0, col = 0 },
		matrix = {}
	}

	map.rows = math.random( minRows, maxRows )
	map.cols = math.random( minCols, maxCols )

	for i = 1, map.rows do
		map.matrix[i] = {}
		for j = 1, map.cols do
			map.matrix[i][j] = math.random( 1, 7 )
		end
	end

	-- Place the goal
	repeat
		map.goal.row = math.random( minRows, map.rows )
		map.goal.col = math.random( minCols, map.cols )	
	until map.matrix[map.goal.row][map.goal.col] ~= BOARD_IMPASSABLE
	map.matrix[map.goal.row][map.goal.col] = BOARD_GOAL

	-- Smarter start positions.
	noStartConflicts = false
	repeat
		map.startRow = math.random( 1, map.rows )
		map.startCol = math.random( 1, map.cols )

		if map.matrix[map.startRow][map.startCol] ~= BOARD_GOAL then
			if map.matrix[map.startRow][map.startCol] ~= BOARD_IMPASSABLE then
				noStartConflicts = true
			end
		end
	until noStartConflicts == true
	rotateCubeTo( map.matrix[map.startRow][map.startCol] )

	return map
end

function reshuffle_board( board )
	for i = 1, map.rows do
		for j = 1, map.cols do
			if map.matrix[i][j] ~= BOARD_IMPASSABLE then
				if map.matrix[i][j] ~= BOARD_GOAL then
					map.matrix[i][j] = math.random( 1, 6 )
				end
			end
		end
	end
end

function load_board( filename )
end

function save_board( filename )
end

board = {
	gridSize = { X = 32, Y = 32 },
	gridSpace = { X = 0, Y = 0 },
	map = create_board( )
}
