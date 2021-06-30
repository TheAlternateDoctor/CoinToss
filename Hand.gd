extends AnimatedSprite


#Base Impact pos: -56 -39
#Catch Impact pos: -76 -30

#Base Woosh pos: -44 -100
#Catch Woosh pos: -59 -99

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func catchCoin():
	animation = "startCatch"
	yield(get_tree().create_timer(0.1), "timeout")
	animation = "catch"


func _on_Game_catch(success):
	if success:
		animation = "startCatch"
		drawTrail()
		yield(get_tree().create_timer(0.1), "timeout")
		animation = "catch"
	else:
		animation = "failCatch"
		$Animations.playback_speed = 16
		$Animations.play("Fail")

func drawTrail():
	$Woosh.position = Vector2(-59,-99)
	$Woosh.visible = true
	
	$Impact.position = Vector2(-76,-30)
	$Impact.visible = true
	yield(get_tree().create_timer(0.02), "timeout")
	$Impact.visible = false
	$Woosh.visible = false

func _on_Game_throw(_step):
	$Woosh.position = Vector2(-44,-100)
	$Woosh.visible = true
	
	$Impact.position = Vector2(-56,-39)
	$Impact.visible = true
	yield(get_tree().create_timer(0.02), "timeout")
	$Impact.visible = false
	$Woosh.visible = false


func _on_Game_catch_fail():
	drawTrail()
	yield(get_tree().create_timer(1), "timeout")
	animation = "search"
	$Animations.playback_speed = 1
	$Animations.play("Search")
	yield(get_tree().create_timer(0.5), "timeout")
	animation = "idle"
	