extends Node

var musicSFXPlayer: Node2D:
	get():
		if musicSFXPlayer == null:
			musicSFXPlayer = get_tree().get_first_node_in_group("musicSfxPlayer")
		return musicSFXPlayer
