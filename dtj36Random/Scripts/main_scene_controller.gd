extends Node2D

@export var challgeOne: Node2D
@export var challgeTwo: Node2D


@export_group("BG Colors")
@export var bg: ColorRect
@export var challgeOneBG: Color
@export var challgeTwoBG: Color
@export var challgeThreeBG: Color
@export var challgeFourBG: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setupSignals()

	# startChallengeOne()


func startChallengeOne():
	tweenBG(challgeOneBG)
	await _create_timer(2)
	challgeOne.showAllObjects()

func startChallengeTwo():
	tweenBG(challgeTwoBG)
	await _create_timer(2)
	# challgeTwo.showAllObjects()


func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setupSignals():
	challgeOne.challengeIsDone.connect(onChallengeOneDone)

func tweenBG(color: Color, duration: float = 3.5):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bg, "color", color, duration)

func onChallengeOneDone():
	print("Challenge one done")
	await _create_timer(3)
	challgeOne.hideAllObjects(true)
	await challgeOne.allObjectsHidden
	startChallengeTwo()


func onChallengeTwoDone():
	print("Challenge two done")
