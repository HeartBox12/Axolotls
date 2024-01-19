extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _on_start_pressed():
	$AnimationPlayer.play("start")

func _on_animation_finished(anim_name):
	if anim_name == "start":
		get_tree().paused = false
		$Main._load()
