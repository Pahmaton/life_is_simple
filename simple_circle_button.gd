extends TouchScreenButton

signal position_button(x, y)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	position_button.emit(self.position.x, self.position.y)
	

