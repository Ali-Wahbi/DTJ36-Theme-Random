extends Node2D

signal challengeIsDone
signal allObjectsHidden

@export var gameLabel: RichTextLabel
@export var correctButton: Button
@export var leftButton: Button
@export var midButton: Button
@export var rightButton: Button
@export var confirmButton: Button
@export var resultLabel: RichTextLabel
@export var realChallengeLabel: RichTextLabel

@export var showDelay: float = 0.25

var isChallengeDone: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllObjects(false, 0)
	# await _create_timer(1)
	# showAllObjects()


func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func showAllObjects() -> void:
	var duration = 0.25
	
	gameLabel.visible = true
	correctButton.visible = true
	print(correctButton.visible, gameLabel.visible)
	tweenFade(gameLabel, 0, 1, duration + showDelay)
	await tweenFade(correctButton, 0, 1, duration + showDelay)

	leftButton.visible = true
	midButton.visible = true
	rightButton.visible = true
	tweenFade(leftButton, 0, 1, duration + showDelay)
	tweenFade(midButton, 0, 1, duration + showDelay)
	tweenFade(rightButton, 0, 1, duration + showDelay)
	

func hideAllObjects(lastLabelInclude: bool = false, duration: float = 0.5) -> void:
	tweenFade(gameLabel, 1, 0, duration)
	tweenFade(correctButton, 1, 0, duration)
	tweenFade(leftButton, 1, 0, duration)
	tweenFade(midButton, 1, 0, duration)
	tweenFade(rightButton, 1, 0, duration)
	tweenFade(confirmButton, 1, 0, duration)
	
	var addedTime: int = 0
	if lastLabelInclude:
		addedTime = 1
		tweenFade(resultLabel, 1, 0, duration)

	await _create_timer(duration * (5 + addedTime))
	gameLabel.visible = false
	correctButton.visible = false
	leftButton.visible = false
	midButton.visible = false
	rightButton.visible = false
	confirmButton.visible = false
	resultLabel.visible = false
	realChallengeLabel.visible = false
	
	allObjectsHidden.emit()


func tweenFade(object: CanvasItem, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished

var isCorrectSelected: bool = false


func _on_game_button_4_pressed() -> void:
	if isCorrectSelected:
		resultLabel.text = "Correct!"
		challengeIsDone.emit()
		isChallengeDone = true
	
	if not resultLabel.visible:
		resultLabel.visible = true
		tweenFade(resultLabel, 0, 1, 0.7)
	

func showConfirmButton():
	if confirmButton.visible or isChallengeDone:
		return
	confirmButton.visible = true
	tweenFade(confirmButton, 0, 1, (0.5 + showDelay))


func _on_correct_pressed() -> void:
	isCorrectSelected = true
	showConfirmButton()


func _on_left_pressed() -> void:
	isCorrectSelected = false
	resultLabel.text = "Not this one"
	showConfirmButton()


func _on_mid_pressed() -> void:
	isCorrectSelected = false
	resultLabel.text = "Nop!"
	showConfirmButton()


func _on_right_pressed() -> void:
	isCorrectSelected = false
	resultLabel.text = "Try the other side"
	showConfirmButton()

func showFinalLabel():
	realChallengeLabel.visible = true
	tweenFade(realChallengeLabel, 0, 1, 0.2)

func hideFinalLabel():
	await tweenFade(realChallengeLabel, 1, 0, 0.2)
	realChallengeLabel.visible = false
