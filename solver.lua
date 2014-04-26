function solve_board( board )
	solution = {}
	attempts = { u = false, d = false, l = false, r = false }
	retval = { solvable = false, solution = solution }

	-- do a basic check around the area.
	for i = 1, map.rows do 
			solution[i] = {}
			for j = 1, map.cols do 
				solution[i][j] = { attempts }
			end
	end

	return retval
end