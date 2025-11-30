extends Node2D

signal challengeIsDone(score: int)
signal challengeHidden


@onready var label: Label = $Label
@onready var label_bg: Label = $ProgressBar/LabelBg

@onready var progress_bar: ProgressBar = $ProgressBar

var textSize: Tween
var textModule: Tween
var barTweenUp: Tween
var barTweenDown: Tween

var waitTime = 1.5

var waitTimeNormal = 1.4
var waitTimeHard = 1.1
var waitTimeInsane = 0.75

var selectedKey: String = "A":
	set(value):
		selectedKey = value
		TweenText(value)

var gameOver: bool = false
var gameStarted: bool = false
var score := 0

var CongratsList = ["Good!", "Impressive!", "Keep up!",
 					"Well Done!", "ASD", "^>v<v^", "Noice!",
					"WoW", "EOA"]

var LoseListTenth = ["???", "U sure U understand?", "^^^^", "was that on perpose?", "no one saw that."]
var LoseListTwententh = ["My GP could do better", "Almost", "<><><><>", "Rank 41st"]
var LoseListMore = ["Try again!", "vvvv", "close...", "Ouch!"]

const POP_MESSAGE = preload("res://Scenes/pop_message.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# print("size: ", CongratsList.size())
	hideChallenge(0)
	Reset()

func Reset():
	progress_bar.value = 0
	gameOver = false
	score = -1
	$resetLabel.visible = false
	waitTime = waitTimeNormal

# Return the signal after the time in 'sec has passed
func _createTimer(sec: float) -> Signal:
	return get_tree().create_timer(sec).timeout

func _unhandled_input(event):
	if not gameStarted:
		return
	if event is InputEventKey:
		if event.pressed and event.keycode in range(KEY_A, KEY_Z + 1) and !gameOver:
			if event.as_text_keycode() == selectedKey:
				OnCorrectSelected()
				AddCongratsMessage()
		if event.pressed and event.keycode == KEY_R and gameOver:
			Reset()
			OnCorrectSelected()
		if event.pressed and event.keycode == KEY_Q and gameOver:
			onChallengIsDone()
		

func OnCorrectSelected():
	score += 1
	$Timer.start()
	SetTimer()
	$Timer.wait_time = waitTime
	
	TweenProgressBar()
	PickRandomKeyCode()

func SetTimer():
	if score <= 10:
		waitTime = waitTimeNormal
	elif score <= 25:
		waitTime = waitTimeHard
	else:
		waitTime = waitTimeInsane
	

func PickRandomKeyCode():
	var index = randi_range(KEY_A, KEY_Z)
	var inp = InputEventKey.new()
	inp.keycode = index
	selectedKey = inp.as_text_keycode()
	#prints("new keycode:", selectedKey)

func TweenProgressBar():
	if barTweenDown:
		barTweenDown.kill()
	if barTweenUp:
		barTweenUp.kill()
	
	barTweenDown = create_tween()
	barTweenDown.tween_property(progress_bar, "value", 100, 0.1)
	
	barTweenUp = create_tween()
	barTweenUp.tween_property(progress_bar, "value", 0, waitTime - 0.2).set_delay(0.2)

func TweenText(newText):
	if textSize:
		textSize.kill()
	if textModule:
		textModule.kill()
	
	textSize = create_tween().set_parallel()
	textModule = create_tween().set_parallel()
	
	label.modulate.a = 0
	label_bg.modulate.a = 0
	
	label.scale = Vector2(2, 2)
	label_bg.scale = Vector2(2, 2)
	
	label.text = newText
	label_bg.text = newText
	
	textSize.tween_property(label, "scale", Vector2.ONE, 0.3)
	textSize.tween_property(label_bg, "scale", Vector2.ONE, 0.3)
	
	textModule.tween_property(label, "modulate:a", 1, 0.2)
	textModule.tween_property(label_bg, "modulate:a", 1, 0.2)


func _on_timer_timeout() -> void:
	gameOver = true
	$resetLabel.visible = true
	prints("Scored: ", score)
	AddLostMessage()
	AddLostMessage()
	label.text = "Game Over!!\n You scored " + str(score)

func AddCongratsMessage():
#	add distracting congrats word around the screen
	var pickedText = CongratsList.pick_random()
	AddPopMessage(pickedText)

func AddLostMessage():
	var pickedList: Array
	
	if score <= 10:
		pickedList = LoseListTenth
	elif score <= 20:
		pickedList = LoseListTwententh
	else:
		pickedList = LoseListMore
	
	var pickedText = pickedList.pick_random()
	AddPopMessage(pickedText)

func AddPopMessage(text: String):
	var pop: popMessage = POP_MESSAGE.instantiate()
	pop.setText(text)
	add_child(pop)


func tweenFade(object: CanvasItem, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished

func showChallenge(duration: float = 0.7):
	tweenFade(self, 0, 1, duration)

func startChallenge():
	gameStarted = true

func hideChallenge(duration: float = 0.5):
	await tweenFade(self, 1, 0, duration)
	challengeHidden.emit()


func onChallengIsDone():
	challengeIsDone.emit(score)
