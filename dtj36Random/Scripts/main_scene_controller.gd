extends Node2D
class_name MusicAndSfxPlayer
@export var challengeOne: Node2D
@export var challengeTwo: Node2D
@export var challengeThree: Node2D
@export var challengeFour: Node2D
@export var challengeFive: Node2D
@export var challengeSix: Node2D
@export var challengeSeven: Node2D
@export var title: Node2D
@export var finale: Node2D


@export_group("BG Colors")
@export var bg: ColorRect
@export var challengeOneBG: Color
@export var challengeTwoBG: Color
@export var titleBG: Color
@export var challengeThreeBG: Color
@export var challengeFourBG: Color
@export var challengeFiveBG: Color
@export var challengeSixBG: Color
@export var challengeSevenBG: Color


@export_group("Challenges Delays")
@export var challengeOneDelay: float
@export var challengeTwoDelay: float
@export var challengeThreeDelay: float
@export var challengeFourDelay: float
@export var challengeFiveDelay: float
@export var challengeSixDelay: float
@export var challengeSevenDelay: float
@export var titleDelay: float

var isChallengeOneDone: bool = false
var isChallengeTwoDone: bool = false
var isChallengeThreeDone: bool = false
var isChallengeFourDone: bool = false
var isChallengeFiveDone: bool = false
var isChallengeSixDone: bool = false
var isChallengeSevenDone: bool = false

var isTitleDone: bool = false


var finalScore: int
var playerTexture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllChallenges()
	setupSignals()
	
	startChallengeOne()
	# startChallengeSix()


func hideAllChallenges():
	challengeOne.visible = false
	challengeTwo.visible = false
	challengeThree.visible = false
	challengeFour.visible = false
	challengeFive.visible = false
	challengeSix.visible = false
	challengeSeven.visible = false
	title.visible = false
	finale.visible = false


func startChallengeOne():
	MusicPlayer.musicSFXPlayer.playNormalSlowMusic()
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

func startChallengeThree():
	print("Starting challenge three")
	challengeThree.visible = true
	tweenBG(challengeThreeBG)
	await _create_timer(challengeThreeDelay)
	challengeThree.showAllObjects()

func startChallengeFour():
	print("Starting challenge four")
	challengeFour.visible = true
	tweenBG(challengeFourBG)
	await _create_timer(challengeFourDelay)
	challengeFour.showAllObjects()


func startChallengeFive():
	print("Starting challenge 5")
	challengeFive.visible = true
	tweenBG(challengeFiveBG)
	await _create_timer(challengeFiveDelay)
	challengeFive.showAllObjects()

func startChallengeSix():
	print("Starting challenge 6")
	challengeSix.visible = true
	tweenBG(challengeSixBG)
	await _create_timer(challengeSixDelay)
	challengeSix.showAllObjects()


func startChallengeSeven():
	MusicPlayer.musicSFXPlayer.playNormalFastMusic()
	print("Starting challenge 7")
	challengeSeven.visible = true
	tweenBG(challengeSevenBG)
	await _create_timer(challengeSevenDelay)
	challengeSeven.showChallenge()
	challengeSeven.gameStarted = true

func startTitle():
	print("Starting title")
	title.visible = true
	tweenBG(titleBG)
	await _create_timer(titleDelay)
	title.showAllObjects()

func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout
	

func setupSignals():
	challengeOne.challengeIsDone.connect(onChallengeOneDone)
	challengeTwo.challengeIsDone.connect(onChallengeTwoDone)
	challengeThree.challengeIsDone.connect(onChallengeThreeDone)
	challengeFour.challengeIsDone.connect(onChallengeFourDone)
	challengeFive.challengeIsDone.connect(onChallengeFiveDone)
	challengeSix.challengeIsDone.connect(onChallengeSixDone)
	challengeSeven.challengeIsDone.connect(onChallengeSevenDone)
	title.challengeIsDone.connect(onTitleDone)


func tweenBG(color: Color, duration: float = 3.5):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bg, "color", color, duration)

func onChallengeOneDone():
	if isChallengeOneDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeOneDone = true
	print("Challenge one done")
	await _create_timer(2)
	challengeOne.hideAllObjects(true)
	await challengeOne.allObjectsHidden
	startChallengeTwo()


func onChallengeTwoDone():
	if isChallengeTwoDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeTwoDone = true
	print("Challenge two done")
	await _create_timer(1)
	challengeTwo.hideAllObjects(true)
	await challengeTwo.allObjectsHidden
	startTitle()

func onChallengeThreeDone():
	if isChallengeThreeDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeThreeDone = true
	print("Challenge three done")
	await _create_timer(1)
	challengeThree.hideAllObjects(true)
	await challengeThree.allObjectsHidden
	startChallengeFour()

func onChallengeFourDone():
	if isChallengeFourDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeFourDone = true
	print("Challenge Four done")
	await _create_timer(0.5)
	challengeFour.hideAllObjects(true)
	await challengeFour.allObjectsHidden
	startChallengeFive()
	
func onChallengeFiveDone():
	if isChallengeFiveDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeFiveDone = true
	print("Challenge Five done")
	
	await _create_timer(0.5)
	challengeFive.hideAllObjects(true)

	await challengeFive.allObjectsHidden
	challengeFive.showFinalLabel()

	await _create_timer(2)
	challengeFive.hideFinalLabel()

	await _create_timer(0.5)
	startChallengeSix()

func onChallengeSixDone():
	if isChallengeSixDone:
		return
	MusicPlayer.musicSFXPlayer.playRevealSounds()
	isChallengeSixDone = true
	print("Challenge Six done")
	
	await _create_timer(0.5)
	challengeSix.hideAllObjects(true)

	await challengeSix.allObjectsHidden
	challengeSix.showFinalLabel()

	await _create_timer(2)
	challengeSix.hideFinalLabel()

	await _create_timer(0.5)
	startChallengeSeven()


func onChallengeSevenDone(score: int):
	if isChallengeSevenDone:
		return

	MusicPlayer.musicSFXPlayer.playRevealSounds()
	finalScore = score
	isChallengeSevenDone = true
	print("Challenge Seven done")
	
	await _create_timer(0.5)
	challengeSeven.hideChallenge()

	await challengeSeven.challengeHidden

	await _create_timer(0.5)
	showFinale()

	
func onTitleDone():
	if isTitleDone:
		return
	isTitleDone = true
	print("Title done")
	await _create_timer(1)
	title.hideAllObjects()
	await title.allObjectsHidden
	startChallengeThree()


func showFinale():
	MusicPlayer.musicSFXPlayer.playImpactRevealNormal()
	finale.visible = true
	playerTexture = challengeTwo.getTexture()
	finale.showAllObjects(finalScore, playerTexture)
