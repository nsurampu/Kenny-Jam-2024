extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	#pass # Replace with function body.
	queue_free()


func kill_enemy():
	$AnimatedSprite2D.animation = "defeat"
	$KillTimer.start()


func _on_kill_timer_timeout():
	#pass # Replace with function body.
	queue_free()
	
	
func set_connection():
	
	$ConnectionIndicator.visible = true
