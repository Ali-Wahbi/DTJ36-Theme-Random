extends Node2D

signal challengeIsDone
signal allObjectsHidden

@export var numberLabel: Label
@export var showLabel: Label
@export var resultLabel: Label
@export var maxRange: int = 10

var goalNumber: int = 0
var currentNumber: int = 0

var challengeDone: bool = false
var tries: int = 0

@export var objectToShow: Array[CanvasItem]
@export var showDelay: float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllObjects(false, 0.0)
	
	goalNumber = getRandomNumber()
	numberLabel.text = str(goalNumber)

func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func showAllObjects() -> void:
	var duration = 0.25
	for item in objectToShow:
		item.visible = true
		await tweenFade(item, 0, 1, duration + showDelay)


func hideAllObjects(lastLabelInclude: bool = false, duration: float = 0.5) -> void:
	for item in objectToShow:
		tweenFade(item, 1, 0, duration)
	
	var addedTime: int = 0
	if lastLabelInclude:
		addedTime = 1
		tweenFade(resultLabel, 1, 0, duration)

	await _create_timer(duration * (objectToShow.size() + addedTime))
	for item in objectToShow:
		item.visible = false
	
	allObjectsHidden.emit()


func getRandomNumber():
	return randi_range(0, maxRange)


func updateShownLabel(number: int):
	showLabel.text = str(number)


func _on_game_button_pressed() -> void:
	print("Game button pressed")
	if challengeDone:
		return
	currentNumber = getRandomNumber()
	updateShownLabel(currentNumber)
	tries += 1
	checkChallengeDone()


func checkChallengeDone():
	if goalNumber == currentNumber:
		challengeDone = true
		showLastLabel()
		print("Player succeeded")


func showLastLabel():
	var firstTryMessage = "Succeded in the first try! Did not expect it."
	var manyTriesMessage = "Succeded after " + str(tries) + " tries. Nice."
	resultLabel.text = firstTryMessage if tries == 1 else manyTriesMessage
	tweenFade(resultLabel, 0, 1, 0.7)

	challengeIsDone.emit()


func tweenFade(object: CanvasItem, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished
