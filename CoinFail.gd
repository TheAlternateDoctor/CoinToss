extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if speen:
		rotation_degrees -= 30 


func _on_Game_catch_fail():
	$Animation.play("Fall")
	speen = true
	visible = true

func _on_Animation_animation_finished(_anim_name):
	speen = false
	visible = false
