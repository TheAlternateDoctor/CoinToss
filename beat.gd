extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (AudioStream) var cowbell
export (AudioStream) var cowbell2
export (AudioStream) var up
export (AudioStream) var down
export (AudioStream) var right
export (AudioStream) var laugh1
export (AudioStream) var laugh2
export (AudioStream) var laugh3
export (AudioStream) var laugh4

signal changeTheme(laugh)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func playCowbell(bpm):
	emit_signal("changeTheme",false)
	var step:float = 60*1000/bpm
	pitch_scale = 1
	for i in range(1,8):
		if i % 2:
			stream = cowbell
		else:
			stream = cowbell2
		play()
		yield(get_tree().create_timer(step/1000), "timeout")
		
#Swing levels: 50, 60, 67, 75
func playBeat(bpm, level, effect):
	var step:float
	var newStep:float
	var onbeat = false
	var offbeat = false
	var cowbellEffect = false
	var laugh = false
	pitch_scale = 1
	match effect:
		0:# No effect
			step = 60*1000/bpm/2
			newStep = step
		1:# Light Swing
			step = 60*1000/bpm/10*4
			newStep = step*1.5
		2:# Swing
			step = 60*1000/bpm/3
			newStep = step*2
		3:# Heavy Swing
			step = 60*1000/bpm/4
			newStep = step*3
		4:# Onbeat
			step = 60*1000/bpm/2
			newStep = step
			onbeat = true
		5:# Offbeat
			step = 60*1000/bpm/2
			newStep = step
			offbeat = true
		6:# Cowbell
			step = 60*1000/bpm/2
			newStep = step
			cowbellEffect = true
		7:# Laughtrack
			step = 60*1000/bpm/2
			newStep = step
			laugh = true
	if not laugh:
		emit_signal("changeTheme",false)
		for i in range(1,7):
			if cowbellEffect:
				stream = cowbell
			elif i % 2:
				stream = up
			else:
				stream = right
			if ((level < 1 or i != 5) and (level < 3 or i <5)) and not offbeat:
				print("Playing Onbeat")
				play()
			yield(get_tree().create_timer(newStep/1000-0.01), "timeout")
			if cowbellEffect:
				stream = cowbell2
			else:
				stream = down
			if (level < 2 or i < 5) and not onbeat:
				print("Playing Offbeat")
				play()
			yield(get_tree().create_timer(step/1000-0.01), "timeout")
		if cowbellEffect:
			stream = cowbell
		else:
			stream = up
		play()
	else:
		emit_signal("changeTheme",true)
		match level:
			0:
				stream = laugh1
			1:
				stream = laugh2
			2:
				stream = laugh3
			3:
				stream = laugh4
		pitch_scale = bpm/120.0
		play()
