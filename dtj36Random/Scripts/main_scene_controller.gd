extends Node2D

@export var challengeOne: Node2D
@export var challengeTwo: Node2D
@export var title: Node2D


@export_group("BG Colors")
@export var bg: ColorRect
@export var challengeOneBG: Color
@export var challengeTwoBG: Color
@export var titleBG: Color
@export var challengeThreeBG: Color
@export var challengeFourBG: Color


@export_group("Challenges Delays")
@export var challengeOneDelay: float
@export var challengeTwoDelay: float
@export var titleDelay: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllChallenges()
	setupSignals()
	# startTitle()
	startChallengeOne()


func hideAllChallenges():
	challengeOne.visible = false
	challengeTwo.visible = false
	title.visible = false


func startChallengeOne():
	print("Starting challenge one")
	challengeOne.visible = true
	tweenBG(challengeOneBG)
	await _create_timer(challengeOneDelay)
	challengeOne.showAllObjects()

func startChallengeTwo():
	print("Starting challenge two")
	challengeTwo.visible = true
	tweenBG(challengeTwoBG)
	await _create_timer(challengeTwoDelay)
	challengeTwo.showAllObjects()

func startTitle():
	print("Starting title")
	title.visible = true
	tweenBG(titleBG)
	await _create_timer(titleDelay)
	title.showAllObjects()

func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setupSignals():
	challengeOne.challengeIsDone.connect(onChallengeOneDone)
	challengeTwo.challengeIsDone.connect(onChallengeTwoDone)
	title.challengeIsDone.connect(onTitleDone)


func tweenBG(color: Color, duration: float = 3.5):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bg, "color", color, duration)

func onChallengeOneDone():
	print("Challenge one done")
	await _create_timer(1)
	challengeOne.hideAllObjects(true)
	await challengeOne.allObjectsHidden
	startChallengeTwo()


func onChallengeTwoDone():
	print("Challenge two done")
	await _create_timer(1)
	challengeTwo.hideAllObjects(true)
	await challengeTwo.allObjectsHidden
	startTitle()

func onTitleDone():
	print("Title done")
	await _create_timer(1)
	title.hideAllObjects()
	await title.allObjectsHidden
	# startChallengeOne()
