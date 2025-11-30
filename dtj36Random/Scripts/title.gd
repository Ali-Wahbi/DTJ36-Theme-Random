extends Node2D

signal challengeIsDone
signal allObjectsHidden

@export var firstLabel: RichTextLabel
@export var secondLabel: RichTextLabel
@export var thirdLabel: RichTextLabel
@export var foarthLabel: RichTextLabel

@export var firstDelay: float = 0.5
@export var secondDelay: float = 0.5
@export var thirdDelay: float = 0.5
@export var foarthDelay: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	firstLabel.visible = false
	secondLabel.visible = false
	thirdLabel.visible = false
	foarthLabel.visible = false


func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func showAllObjects(duration: float = 0.5):
	await _create_timer(firstDelay)
	firstLabel.visible = true
	await tweenFade(firstLabel, 0, 1, duration)

	await _create_timer(secondDelay)
	secondLabel.visible = true
	await tweenFade(secondLabel, 0, 1, duration)

	await _create_timer(thirdDelay)
	thirdLabel.visible = true
	await tweenFade(thirdLabel, 0, 1, duration)

	await _create_timer(foarthDelay)
	foarthLabel.visible = true
	await tweenFade(foarthLabel, 0, 1, duration + 0.5)

	challengeIsDone.emit()


func hideAllObjects(duration: float = 0.5):
	tweenFade(firstLabel, 1, 0, duration)
	tweenFade(secondLabel, 1, 0, duration)
	tweenFade(thirdLabel, 1, 0, duration)
	tweenFade(foarthLabel, 1, 0, duration)

	await _create_timer(duration * 4)
	allObjectsHidden.emit()


func tweenFade(object: RichTextLabel, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished
