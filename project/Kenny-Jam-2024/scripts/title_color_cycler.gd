extends RichTextLabel


var color_cycle = [Color.AQUA, Color.DEEP_PINK, Color.GREEN_YELLOW]
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var to_color = color_cycle[counter % len(color_cycle)]
	add_theme_color_override("default_color", to_color)


func _on_title_cycle_counter_timeout():
	#pass # Replace with function body.
	counter += 1
