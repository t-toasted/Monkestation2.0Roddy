/datum/cracker_puzzle
	var/grid = list()
	var/grid_size = 5 //this generates squares
	///our sequence we need
	var/sequence = list()
	///our current buffer
	var/list/buffer = list()
	///our current timer
	var/current_timer_id = FALSE
	///our difficulty
	var/difficulty = 1
	///our letters
	var/list/combinations = list("A", "B", "C", "D", "E", "F", "G")
	var/is_vertical = FALSE
	///blocking message
	var/blocking_message = null

	var/datum/parent

	var/list/plotted_points = list()

/datum/cracker_puzzle/New(grid_size = 5, difficulty = 1, datum/parent)
	src.grid_size = grid_size
	src.difficulty = difficulty
	src.parent = parent

	//generate_combination_strings()
	generate_sequence()

/datum/cracker_puzzle/Destroy(force)
	. = ..()
	parent = null

/datum/cracker_puzzle/proc/generate_combination_strings()
	combinations = list()
	for(var/i = 1 to 7)
		combinations += "[pick(GLOB.alphabet_upper)][pick(GLOB.numerals)]"

/datum/cracker_puzzle/proc/generate_sequence()
	for(var/i = 1 to grid_size)
		var/list/choices = list()
		for(var/b = 1 to grid_size)
			choices += pick(combinations)
		grid += list(choices)

	generate_crack()

/datum/cracker_puzzle/proc/generate_crack()

	var/sequence_length = 4 + difficulty

	var/last_sequence_spot = rand(1, grid_size)
	var/last_vertical_sequence_spot = rand(1, grid_size)
	var/vertical = FALSE
	for(var/i = 1 to sequence_length)
		if(vertical)
			var/vertical_spot = rand(1, grid_size)  // Random row (y-coordinate)
			var/list/horizontal_cut_vert = grid[vertical_spot]  // Get the row corresponding to vertical_spot
			sequence += horizontal_cut_vert[last_sequence_spot]  // Use the last x-coordinate to select the letter
			last_vertical_sequence_spot = vertical_spot  // Update the y-coordinate
			plotted_points += "[last_sequence_spot], [last_vertical_sequence_spot]"  // Log the coordinate pair
			vertical = FALSE  // Switch to horizontal for the next iteration
		else
			var/horizontal_spot = rand(1, grid_size)  // Random column (x-coordinate)
			sequence += grid[last_vertical_sequence_spot][horizontal_spot]  // Access the column in the current row
			last_sequence_spot = horizontal_spot  // Update the x-coordinate
			plotted_points += "[last_sequence_spot], [last_vertical_sequence_spot]"  // Log the coordinate pair
			vertical = TRUE  // Switch to vertical for the next iteration


/datum/cracker_puzzle/proc/check_press(x, y)
	buffer += list(list(x,y))
	if(!vertical_check())
		failure()
	is_vertical = !is_vertical

	if(!check_sequence())
		failure()
	if(check_finished())
		success()


/datum/cracker_puzzle/proc/check_finished()
	if(length(buffer) == length(sequence))
		return TRUE
	return FALSE

/datum/cracker_puzzle/proc/success()
	blocking_message = "Succeeded"
	SEND_SIGNAL(parent, COMSIG_CRACKER_PUZZLE_SUCCESS)

/datum/cracker_puzzle/proc/vertical_check()
	if(length(buffer) <= 1)
		return TRUE

	var/list/last_coords = list()
	last_coords = buffer[length(buffer) - 1]

	var/list/coords = list()
	coords = buffer[length(buffer)]

	if(is_vertical)
		if(last_coords[1] != coords[1])
			return FALSE
	else
		if(last_coords[2] != coords[2])
			return FALSE

	return TRUE

/datum/cracker_puzzle/proc/check_sequence()
	for(var/i = 1 to length(buffer))
		var/list/coords = buffer[i]

		var/value = grid[coords[2]][coords[1]]

		if(sequence[i] != value)
			return FALSE
	return TRUE

/datum/cracker_puzzle/proc/failure()
	buffer = list()
	grid = list()
	sequence = list()
	is_vertical = FALSE

	blocking_message = "Failed"
	addtimer(CALLBACK(src, PROC_REF(clear_block), 3 SECONDS))
	SEND_SIGNAL(parent, COMSIG_CRACKER_PUZZLE_FAILURE)

	generate_sequence()

/datum/cracker_puzzle/proc/clear_block()
	blocking_message = null


/datum/cracker_puzzle/ui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrackerPuzzle", "Genetic Sequence")
		ui.open()

/datum/cracker_puzzle/ui_state()
	return GLOB.always_state

/datum/cracker_puzzle/ui_data(mob/user)
	var/list/data = list()

	var/horiztonal = 0
	if(length(buffer))
		horiztonal = buffer[length(buffer)][1]

	var/vertical = 0
	if(length(buffer))
		vertical = buffer[length(buffer)][2]

	data["grid"] = grid
	data["buffer"] = buffer
	data["sequence"] = sequence
	data["is_vertical"] = is_vertical
	data["horizontal_loc"] = horiztonal
	data["vertical_loc"] = vertical
	data["blocking_message"] = blocking_message

	return data

/datum/cracker_puzzle/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("press_button")
			check_press(params["x"], params["y"])
