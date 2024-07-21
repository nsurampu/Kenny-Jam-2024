extends Node


var player_hit = false
var var_player_out_of_bounds = false
var player_survived = false
var max_val = 0
var total_val = 0
var multiplier = 1
var current_score = 0
var session_score = 0
var connected_enemies = []
var accounted_enemies = []
var connected_types = {0: 0, 1: 0, 2: 0}

var ENEMY_SPEED = 50

func calculate_score():
	
	get_stats()
	
	return ceil(total_val * multiplier)
		
		
func get_stats():
	
	max_val = max(connected_types[0], connected_types[1], connected_types[2])
	total_val = connected_types[0] + connected_types[1] + connected_types[2]
	
	if total_val < 5:
		multiplier = 1
	elif total_val >= 5 and total_val < 10:
		if max_val / total_val == 1:
			multiplier = 2
		elif max_val / total_val >= 0.4:
			multiplier = 1.5
		else:
			multiplier = 1.2
	else:
		if max_val / total_val == 1:
			multiplier = 4
		elif max_val / total_val >= 0.4:
			multiplier = 2
		else:
			multiplier = 1.5
	

func reset_stats():
	
	max_val = 0
	total_val = 0
	connected_types = {0: 0, 1: 0, 2: 0}
	
	
func reset():
	
	player_hit = false
	var_player_out_of_bounds = false
	player_survived = false
	connected_enemies = []
	accounted_enemies = []
	connected_types = {0: 0, 1: 0, 2: 0}
	max_val = 0
	total_val = 0
	

func _process(delta):
	
	var chain_score = calculate_score()
	#print(current_score, chain_score)
	
	if current_score + chain_score <= 15:
		ENEMY_SPEED = 50
	elif current_score + chain_score <= 25:
		ENEMY_SPEED = 75
	elif current_score + chain_score <= 35:
		ENEMY_SPEED = 110
	elif current_score + chain_score <= 40:
		ENEMY_SPEED = 170
	else:
		ENEMY_SPEED = 250
