extends Node2D

signal challengeIsDone
signal allObjectsHidden

@export var texturesForReflection: Array[Texture]
@export var sprite: Sprite2D
@export var slider: Slider

@export var objectToShow: Array[CanvasItem]
@export var showDelay: float = 0.25

@export var finishButton: Button
var finishButtonShown: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllObjects(false, 0.0)
	slider.max_value = texturesForReflection.size()
	

func _on_h_slider_value_changed(_value: float) -> void:
	showFinishButton()
	randomizeSprite()

func randomizeSprite():
	# if sprite.texture == null:
	var index = randi_range(0, texturesForReflection.size() - 1)
	await tweenFade(sprite, 1, 0, 0.2)
	sprite.texture = texturesForReflection[index]
	tweenFade(sprite, 0, 1, 0.1)


func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func showAllObjects() -> void:
	var duration = 0.25
	for item in objectToShow:
		item.visible = true
		await tweenFade(item, 0, 1, duration + showDelay)


func hideAllObjects(finishButtonIncluded: bool = false, duration: float = 0.5) -> void:
	for item in objectToShow:
		tweenFade(item, 1, 0, duration)
	
	var addedTime: int = 0
	if finishButtonIncluded:
		addedTime = 2
		tweenFade(finishButton, 1, 0, duration)
		tweenFade(sprite, 1, 0, duration)

	await _create_timer(duration * (objectToShow.size() + addedTime))
	for item in objectToShow:
		item.visible = false
	
	allObjectsHidden.emit()

var tween: Tween
func tweenFade(object: CanvasItem, from: float, to: float, duration: float, killTween: bool = false) -> Signal:
	if tween and killTween:
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished


func _on_game_button_pressed() -> void:
	challengeIsDone.emit()

func showFinishButton():
	if finishButtonShown:
		return
	finishButtonShown = true
	tweenFade(finishButton, 0, 1, 0.7, true)
