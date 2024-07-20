extends Node2D


@export var blue_enemy: PackedScene
@export var red_enemy: PackedScene
@export var green_enemy: PackedScene

const ENEMY_SPEED = 50
const ENEMY_TYPE = ["blue", "green", "red"]
var velocity = Vector2(ENEMY_SPEED, 0.0)

var score
var enemies
var player_position
var current_type

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	
	if SignalBus.player_hit:
		end_game()
		
	SignalBus.get_stats()
	$TotalChainSize.set_text("Current Chain Size: " + str(SignalBus.total_val))
	$BestChainSize.set_text("Connection Power: " + str(SignalBus.max_val))
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			player_position = $Player.position
			var direction = enemy.position.direction_to(player_position)
			enemy.linear_velocity = direction * ENEMY_SPEED
		else:
			enemies.erase(enemy)
			
	for enemy in SignalBus.connected_enemies:
		if enemy not in SignalBus.accounted_enemies:
			enemy.set_connection()
			SignalBus.connected_types[enemy.get_meta("enemy_type")] += 1
			SignalBus.accounted_enemies.append(enemy)
			
	if Input.is_action_pressed("burst"):
		for enemy in SignalBus.connected_enemies:
			SignalBus.connected_enemies.erase(enemy)
			SignalBus.accounted_enemies.erase(enemy)
			enemies.erase(enemy)
			enemy.kill_enemy()
		score += SignalBus.calculate_score()
			
	if Input.is_action_just_released("switch_type"):
		current_type = (current_type + 1) % 3
		
	
func new_game():
	score = 0
	enemies = []
	$SpawnTimer.start()
	$Player.position = $PlayerSpawn.position
	current_type = 0
	SignalBus.reset()
	spawn_enemy()
	
	
func end_game():
	print("Score: ", score)
	get_tree().paused = true
	
	
func _on_spawn_timer_timeout():
	#pass # Replace with function body.
	#print("Spawning Enemy...")
	spawn_enemy()
	
	
func spawn_enemy():
	
	var enemy_idx = randi() % 3
	var enemy
	
	if enemy_idx == 0:
		enemy = blue_enemy.instantiate()
		#print("BLUE!")
	elif enemy_idx == 1:
		enemy = red_enemy.instantiate()
		#print("RED!")
	else:
		enemy = green_enemy.instantiate()
		#print("GREEN")
		
	var spawn_point = $EnemySpawnPath/EnemySpawnLocation
	spawn_point.progress_ratio = randf()
	var direction = spawn_point.rotation + PI / 2
	enemy.position = spawn_point.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	enemy.linear_velocity = velocity.rotated(direction)

	enemies.append(enemy)
	add_child(enemy)
