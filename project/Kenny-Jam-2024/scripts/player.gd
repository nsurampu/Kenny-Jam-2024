extends RigidBody2D

const PLAYER_SPEED = 400
var screen_size
var contacted_enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * PLAYER_SPEED
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "chase_horizontal"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "chase_vertical"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	if Input.is_action_just_pressed("connect_enemy"):
		$AuraField.play()
		
	if Input.is_action_just_pressed("burst"):
		$Burst.play()
	
	if Input.is_action_pressed("connect_enemy"):
		$ConnectionArea/Polygon2D.color = Color(1, 0.75, 0, 0.4)
		contacted_enemies = $ConnectionArea.get_overlapping_bodies()
		if len(contacted_enemies) > 0:
			for enemy in contacted_enemies:
				if enemy not in SignalBus.connected_enemies:
					SignalBus.connected_enemies.append(enemy)
	else:
		$ConnectionArea/Polygon2D.color = Color(1, 0.75, 0, 0.2)
	
	if SignalBus.player_hit:
		$AnimatedSprite2D.animation = "defeat"
	
	$AnimatedSprite2D.play()


func _on_body_entered(body):
	#pass # Replace with function body.
	SignalBus.player_hit = true


func _on_connection_area_body_entered(body):
	#pass # Replace with function body.
	if Input.is_action_pressed("connect_enemy"):
		if body not in SignalBus.connected_enemies:
			SignalBus.connected_enemies.append(body)


func _on_visible_on_screen_notifier_2d_screen_exited():
	#pass # Replace with function body.
	$OffscreenTimer.start()


func _on_visible_on_screen_notifier_2d_screen_entered():
	#pass # Replace with function body.
	$OffscreenTimer.stop()


func _on_offscreen_timer_timeout():
	#pass # Replace with function body.
	SignalBus.var_player_out_of_bounds = true
