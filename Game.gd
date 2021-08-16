extends Node2D


# TODO:
# Effects! Swing, Onbeat/Offbeat, Laugh track(?), MORE COWBELLS

var thrown:bool = false
var cowbell:bool = true

var level = 0
var tempo = 120
var step:float = 60*1000/tempo
var interval:float = 60*1000/120/5
var effect = 0
var catchTime
var gotInput = false
var checkedInput = false
var beatTime = 0

var lockInput = false
var holding = false
var lastPos:Vector2

var effectsName = ["","Light Swing","Swing","Heavy Swing","Onbeat only","Offbeat only","Cowbells","*Laughter*"]
var effectsWeight = [10,10,10,30,15,15,30]
var rng = RandomNumberGenerator.new()

signal throw(step)
signal catch(success)
signal catch_fail
signal update_record(record)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = OS.get_unix_time()
	var save_game = File.new()
	if not save_game.file_exists("user://record.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://record.save", File.READ)
	emit_signal("update_record",save_game.get_8())
	save_game.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if gotInput and not checkedInput:
		checkInput()
	if thrown:
		if beatTime+interval < OS.get_ticks_msec():
			checkedInput = false
			emit_signal("catch_fail")
			level = 0
			cowbell = true
			tempo = 120
			step = 60*1000/tempo
			effect = generateEffect()
			thrown = false
			gotInput = false
			lockInput = true
			print("GAME OVER")

func generateEffect():
	if $EffectQuestion.pressed:
		var totalWeight = 0
		for weight in effectsWeight:
			totalWeight += weight
		var randomEffect = rng.randi_range(0,totalWeight)
		var actualWeight = 0
		print(randomEffect)
		for number in range(0,effectsWeight.size()):
			actualWeight += effectsWeight[number]
			if actualWeight>=randomEffect:
				print(number)
				return number+1
	else:
		return 0

func _input(event):
	if event is InputEventScreenTouch:
		if not holding and thrown:
			handleInput("touch")
			lastPos = event.position
		lastPos = event.position
		if holding:
			holding = false
		else:
			holding = true
	if event is InputEventScreenDrag:
		var firstPos = lastPos
		lastPos = event.position
		var travelDistance = firstPos.y - lastPos.y
		print(str(travelDistance))
		if travelDistance > 20:
			handleInput("flick")

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_SPACE) and not lockInput and not event.is_echo():
		handleInput("kb")

func handleInput(type):
	if not thrown and type != "touch":
		$EffectQuestion.visible = false
		$EffectQuestion.disabled = true
		$Effect.text = effectsName[effect]
		$Effect.visible = true
		$Hand.play("throw")
		beatTime = OS.get_ticks_msec()+step*6
		$Coin.play()
		if not cowbell:
			$Screen.visible = false
			$beat.playBeat(tempo,level, effect)
			level+=1
		else:
			$Screen.visible = true
			$beat.playCowbell(tempo)
			cowbell = false
		emit_signal("throw",step)
		thrown = true
	elif thrown and type != "flick":
		if not gotInput:
			gotInput = true
			if checkedInput:
				emit_signal("catch",false)
				gotInput = false
	elif thrown and type == "flick":
		if checkedInput:
			checkedInput = false
		$Hand.play("throw")

func checkInput():
	catchTime = OS.get_ticks_msec()
	checkedInput = true
	gotInput = false
	if beatTime-interval < catchTime or beatTime+interval < catchTime:
		checkedInput = false
		gotInput = false
		thrown = false
		emit_signal("catch",true)
		if level > 3:
			level = 0
			cowbell = true
			tempo -= tempo/10
			step = 60*1000/tempo
			effect = generateEffect()
	elif beatTime-interval > catchTime:
		emit_signal("catch",false)


func _on_Animations_animation_finished(anim_name):
	if anim_name == "Search":
		$EffectQuestion.visible = true
		$EffectQuestion.disabled = false
		$Effect.visible = false
		lockInput = false
		$Screen.visible = true
		$Screen.reset()

func _on_EffectQuestion_toggled(button_pressed):
	if button_pressed:
		effect = generateEffect()
	else:
		effect = 0

func _on_ScoreBox_new_record(record):
	var save_game = File.new()
	save_game.open("user://record.save", File.WRITE)
	save_game.store_8(record)
	save_game.close()
