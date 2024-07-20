extends Node


var player_hit = false
var max_val = 0
var total_val = 0
var connected_enemies = []
var accounted_enemies = []
var connected_types = {0: 0, 1: 0, 2: 0}

func calculate_score():
	
	get_stats()
	
	if total_val > 5:
		return ceil((1 + max_val / total_val) * max_val + (total_val - max_val))
	else:
		return total_val
		
		
func get_stats():
	
	max_val = max(connected_types[0], connected_types[1], connected_types[2])
	total_val = connected_types[0] + connected_types[1] + connected_types[2]	
	
	
func reset():
	
	player_hit = false
	connected_enemies = []
	connected_types = {0: 0, 1: 0, 2: 0}
	max_val = 0
	total_val = 0
