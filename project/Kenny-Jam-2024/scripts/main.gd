extends Node2D


@export var blue_enemy: PackedScene
@export var red_enemy: PackedScene
@export var green_enemy: PackedScene
@export var enemy_limit: int

var ENEMY_SPEED = SignalBus.ENEMY_SPEED
var velocity = Vector2(ENEMY_SPEED, 0.0)

var score
var total_enemies
var enemies = []
var player_position
var on_texture
var off_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	#new_game()
	on_texture = load("res://assets/PNG/Items/buttonGreen.png")
	off_texture = load("res://assets/PNG/Items/buttonRed.png")
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	
	if not get_tree().paused:
		
		if total_enemies >= enemy_limit and len(enemies) == 0:
			SignalBus.player_survived = true
		
		ENEMY_SPEED = SignalBus.ENEMY_SPEED
		velocity = Vector2(ENEMY_SPEED, 0.0)
		SignalBus.current_score = score
		#print(ENEMY_SPEED)
		
		if SignalBus.var_player_out_of_bounds:
			end_game("You Abandoned Battle")
		if SignalBus.player_hit:
			end_game("You Were Hit")
		if SignalBus.player_survived:
			end_game("You Survived")
			
		if Input.is_action_pressed("connect_enemy"):
			$ConnectorPower.set_texture(on_texture)
			$ConnectorStatus.set_text("VAB: Online")
		else:
			$ConnectorPower.set_texture(off_texture)
			$ConnectorStatus.set_text("VAB: Offline")
			
		SignalBus.get_stats()
		$Score.set_text("Score: " + str(score))
		$TotalChainSize.set_text("Current Chain Size: " + str(SignalBus.total_val))
		$BestChainSize.set_text("Connection Power: " + str(SignalBus.max_val))
		$Multiplier.set_text("Score Multiplier: " + str(SignalBus.multiplier))
		
		for enemy in enemies:
			if is_instance_valid(enemy):
				player_position = $Player.position
				var direction = enemy.position.direction_to(player_position)
				#var facing_direction = enemy.position - enemy._position_last_frame
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
			SignalBus.reset_stats()
		
	
func new_game():
	$Player.visible = true
	$EndMessage.visible = false
	$FinishMessage.visible = false
	$Score.visible = true
	$TotalChainSize.visible = true
	$BestChainSize.visible = true
	$ConnectorStatus.visible = true
	$ConnectorPower.visible = true
	$SessionScore.visible = true
	$Multiplier.visible = true
	$Title.visible = false
	$SessionScoreOverview.visible = false
	$ScoreOverview.visible = false
	if len(enemies) > 0:
		for enemy in enemies:
			enemy.destroy_enemy()
	total_enemies = 0
	get_tree().paused = false
	score = 0
	enemies = []
	$SpawnTimer.start()
	$Player.position = $PlayerSpawn.position
	SignalBus.reset()
	spawn_enemy()
	
	
func end_game(end_message):
	#print("Score: ", score)
	if SignalBus.player_survived:
		$GameFinish.play()
		SignalBus.session_score = max(score, SignalBus.session_score)
		$FinishMessage.set_text("[center]" + end_message)
		$FinishMessage.visible = true
		$ControlScheme.visible = false
	else:
		$GameEnd.play()
		SignalBus.session_score = max(score, SignalBus.session_score)
		$EndMessage.set_text("[center]" + end_message)
		$EndMessage.visible = true
		$ControlScheme.visible = true
	$SessionScore.set_text("Session High Score: " + str(SignalBus.session_score))
	$Start.visible = true
	$Score.visible = false
	$TotalChainSize.visible = false
	$BestChainSize.visible = false
	$ConnectorStatus.visible = false
	$ConnectorPower.visible = false
	$SessionScore.visible = false
	$Multiplier.visible = false
	$Title.visible = true
	$SessionScoreOverview.set_text("[center]Session High Score: " + str(SignalBus.session_score))
	$SessionScoreOverview.visible = true
	$ScoreOverview.set_text("[center]Score: " + str(score))
	$ScoreOverview.visible = true
	get_tree().paused = true
	
func _on_spawn_timer_timeout():
	#pass # Replace with function body.
	#print("Spawning Enemy...")
	if total_enemies <= enemy_limit:
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
	total_enemies += 1
	add_child(enemy)


func _on_button_pressed():
	#pass # Replace with function body.
	$ButtonClick.play()
	$Start.visible = false
	$ControlScheme.visible = false
	new_game()
