extends Sprite


# Base pos Units: 0 0
# New pos Units: 5 0

var score = 0
var record = 5

signal new_record(record)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Game_catch(success):
	if success:
		score += 1
		if score == 100:
			score = 99
		if score >= 10:
			$Tenth.visible = true
			$Units.position = Vector2(5,0)
			var number = floor(score/10)
			$Tenth.animation = str(number)
			$Units.animation = str(score - number*10)
		else:
			$Units.animation = str(score)
		if score > record:
			$Record.text = "Record: "+str(score)
			record = score
			emit_signal("new_record", record)


func _on_Animations_animation_finished(anim_name):
	if anim_name == "Search":
		score = 0
		$Tenth.visible = false
		$Units.position = Vector2(0,0)
		$Units.animation = "0"


func _on_Game_update_record(record):
	if record>5:
		$Record.text = "Record: "+str(record)
