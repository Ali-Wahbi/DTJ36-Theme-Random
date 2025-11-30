extends Node2D

@export var youLabel: RichTextLabel
@export var scoreLabel: RichTextLabel
@export var reflectionSprite: Sprite2D

@export var finaleLabel: RichTextLabel
@export var psLabel: RichTextLabel
@export var showDelay: float = 0.25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideAllObjects(0)

func _create_timer(time: float = 0) -> Signal:
	return get_tree().create_timer(time).timeout

func tweenFade(object: CanvasItem, from: float, to: float, duration: float) -> Signal:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	object.modulate.a = from
	tween.tween_property(object, "modulate:a", to, duration)
	return tween.finished

func showAllObjects(score: int, reflection: Texture2D) -> void:
	print("Finale show all objects")
	scoreLabel.text = "Scored: " + str(score)
	reflectionSprite.texture = reflection
	var duration = 0.5
	
	youLabel.visible = true
	reflectionSprite.visible = true
	tweenFade(youLabel, 0, 1, duration)
	tweenFade(reflectionSprite, 0, 1, duration)
	await _create_timer(showDelay)

	scoreLabel.visible = true
	tweenFade(scoreLabel, 0, 1, duration)

	await _create_timer(showDelay * 2)

	finaleLabel.visible = true
	tweenFade(finaleLabel, 0, 1, duration)

	await _create_timer(showDelay * 4)
	psLabel.visible = true
	tweenFade(psLabel, 0, 1, duration)


func hideAllObjects(duration: float = 0.5) -> void:
	tweenFade(youLabel, 1, 0, duration)
	tweenFade(reflectionSprite, 1, 0, duration)
	tweenFade(scoreLabel, 1, 0, duration)
	tweenFade(finaleLabel, 1, 0, duration)
	tweenFade(psLabel, 1, 0, duration)

	youLabel.visible = false
	reflectionSprite.visible = false
	scoreLabel.visible = false
	finaleLabel.visible = false
	psLabel.visible = false
