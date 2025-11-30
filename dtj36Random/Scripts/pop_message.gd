extends Control
class_name popMessage

@onready var label: RichTextLabel = $GameLabel
var text: String

@export var YRange: Vector2
@export var XValues: Vector2

@export var rotationRange: Vector2
var rotateRight: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setText(newText: String):
	text = newText

func setup():
	label.text = text
	setPosition()
	setRotation()
	TweenUp()

func setPosition():
	var yPos = randf_range(YRange.x, YRange.y)
	var xPos
	var xPosIndex = randi_range(0, 100)
	
	if xPosIndex < 40:
		xPos = XValues.x
		rotateRight = false
	else:
		xPos = XValues.y
		rotateRight = true
	
	label.position = Vector2(xPos, yPos)
	

func setRotation():
	var LabelRotation = rotationRange.x if rotateRight else rotationRange.y
	label.rotation = deg_to_rad(LabelRotation)


func TweenUp():
	var tween = create_tween()
	label.modulate.a = 0
	tween.tween_property(label, "modulate:a", 1, 0.4)
	tween.tween_property(label, "modulate:a", 0, 0.4).set_delay(0.4)
	await tween.finished
	call_deferred("queue_free")
