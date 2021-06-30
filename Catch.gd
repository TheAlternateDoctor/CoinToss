extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (AudioStream) var catch
export (AudioStream) var catch_cheer
export (AudioStream) var fail

var isCheer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Game_catch_fail():
	stream = fail
	play()


func _on_Game_catch(success):
	if success:
		if isCheer:
			stream = catch_cheer
		else:
			stream = catch
		play()


func _on_beat_changeTheme(laugh):
	if laugh:
		isCheer = false
	else:
		isCheer = true
