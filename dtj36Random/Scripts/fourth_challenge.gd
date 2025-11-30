extends Node2D

signal challengeIsDone
signal allObjectsHidden

@export var gameLabel: RichTextLabel
@export var redButton: Button
@export var yellowButton: Button
@export var blueButton: Button
@export var confirmButton: Button
@export var resultLabel: RichTextLabel


@export var showDelay: float = 0.25

var isChallengeDone: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllObjects(false, 0)
	# showAllObjects()


func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func showAllObjects() -> void:
	var duration = 0.25
	
	gameLabel.visible = true
	await tweenFade(gameLabel, 0, 1, duration + showDelay)

	redButton.visible = true
	yellowButton.visible = true
	blueButton.visible = true
	tweenFade(redButton, 0, 1, duration + showDelay)
	tweenFade(yellowButton, 0, 1, duration + showDelay)
	tweenFade(blueButton, 0, 1, duration + showDelay)
	

func hideAllObjects(lastLabelInclude: bool = false, duration: float = 0.5) -> void:
	tweenFade(gameLabel, 1, 0, duration)
	tweenFade(redButton, 1, 0, duration)
	tweenFade(yellowButton, 1, 0, duration)
	tweenFade(blueButton, 1, 0, duration)
	tweenFade(confirmButton, 1, 0, duration)
	
	var addedTime: int = 0
	if lastLabelInclude:
		addedTime = 1
		tweenFade(resultLabel, 1, 0, duration)

	await _create_timer(duration * (5 + addedTime))
	gameLabel.visible = false
	redButton.visible = false
	yellowButton.visible = false
	blueButton.visible = false
	confirmButton.visible = false
	resultLabel.visible = false
	
	allObjectsHidden.emit()


func tweenFade(object: CanvasItem, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished

var isCorrectSelected: bool = false


func _on_blue_pressed() -> void:
	isCorrectSelected = false
	showConfirmButton()


func _on_yellow_pressed() -> void:
	isCorrectSelected = true
	showConfirmButton()

func _on_red_pressed() -> void:
	isCorrectSelected = false
	showConfirmButton()

func _on_game_button_4_pressed() -> void:
	if isCorrectSelected:
		resultLabel.text = "Correct!"
		challengeIsDone.emit()
		isChallengeDone = true
	else:
		resultLabel.text = "Wrong!"
	
	if not resultLabel.visible:
		resultLabel.visible = true
		tweenFade(resultLabel, 0, 1, 0.7)
	

func showConfirmButton():
	if confirmButton.visible or isChallengeDone:
		return
	confirmButton.visible = true
	tweenFade(confirmButton, 0, 1, (0.5 + showDelay))