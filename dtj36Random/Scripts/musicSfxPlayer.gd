extends Node2D

@export var sfxPlayer: AudioStreamPlayer2D
@export var musicPlayer: AudioStreamPlayer2D

@export_group("SFXs")
@export var revealEffects: Array[AudioStream]
@export var impactRevealNormal: AudioStream
@export var impactRevealStrong: AudioStream

@export_group("Musics")
@export var musicSlowNormal: AudioStream
@export var musicFastNormal: AudioStream
@export var musicFastHard: AudioStream
@export var musicFastInsane: AudioStream

var musicDBLowest = -6.0
var musicDBHighest = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func playNormalSlowMusic():
	musicPlayer.stream = musicSlowNormal
	musicPlayer.playing = true

func playNormalFastMusic():
	musicPlayer.stream = musicFastNormal
	musicPlayer.playing = true

func playHardFastMusic():
	musicPlayer.stream = musicFastHard
	musicPlayer.playing = true

func playInsaneFastMusic():
	musicPlayer.stream = musicFastInsane
	musicPlayer.playing = true

func playRevealSounds():
	sfxPlayer.stream = pickRandomReveal()
	sfxPlayer.playing = true


func stopMusic():
	musicPlayer.playing = false

func stopSfx():
	sfxPlayer.playing = false

func pickRandomReveal():
	var maxIndex = revealEffects.size() - 1
	var index = randi_range(0, maxIndex)

	return revealEffects[index]
