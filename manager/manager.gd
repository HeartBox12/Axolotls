extends Node2D
var mainScene = preload("res://Map/maps.tscn")
var instance:Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _on_start_pressed():
	instance = mainScene.instantiate()
	instance.position = Vector2(0, 0)
	add_child(instance)
	$AnimationPlayer.play("start")
	get_tree().paused = false

func _on_animation_finished(anim_name):
	if anim_name == "start":
		instance._load()
