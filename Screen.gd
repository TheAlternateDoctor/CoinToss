extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ticking = false
var interval = -1
var startTicking = 0
var elapsed = 0
var numbers = [0,0,0]
var failed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ticking:
		elapsed = getElapsed()
		if elapsed >= 100:
			var number = floor(elapsed/100)
			if number == 4:
				reset()
			else:
				numbers[0] = number
				$"Big Number".animation = str(number)
		if elapsed >= 10:
			var number = floor(elapsed/10-numbers[0]*10)
			numbers[1] = number
			$Tenth.animation = str(number)
		var number = floor(elapsed-numbers[0]*100-numbers[1]*10)
		numbers[2] = number
		$Units.animation = str(number)

func getElapsed():
	return (OS.get_ticks_msec() - startTicking) /interval

func reset():
	numbers = [0,0,0]
	$"Big Number".animation = "0"
	$Tenth.animation = "0"
	$Units.animation = "0"
	ticking = false
	

func _on_Game_throw(step):
	if visible:
		numbers = [0,0,0]
		$"Big Number".animation = "0"
		$Tenth.animation = "0"
		$Units.animation = "0"
		ticking = true
		interval = step*6/300
		startTicking = OS.get_ticks_msec()


func _on_Game_catch(success):
	if success:
		ticking = false
	else:
		failed = true
