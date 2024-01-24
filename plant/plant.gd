extends Area2D

@export var health:float = 5
var profit = 0 #The current number of limes

signal destroyed
signal picked

func _ready():
	var poofOrientation = randi_range(1, 16)
	if poofOrientation >= 8:
		$poof.flip_h = true
		poofOrientation -= 8
	if poofOrientation >= 4:
		$poof.flip_v = true
		poofOrientation -= 4
	match poofOrientation:
		1:
			$poof.rotation_degrees = 0
		2:
			$poof.rotation_degrees = 90
		3:
			$poof.rotation_degrees = 180
		4:
			$poof.rotation_degrees = 270
	$poof.play("default")

	Global.Daytime.connect(ripen)

func ripen():
	if profit == 0: #This plant is not yet ripe, but will ripen.
		$sprite.play("ripen")
		profit = 1
	elif profit == 1: #The plant is ripe, and will mature
		$sprite.play("maturing")
		profit = 3
	elif profit == 3: #The plant is mature, and will die
		health = 0

func _process(_delta):
	if health <= 0:
		$AnimationPlayer.play("death")
		match profit:
			0:
				$sprite.animation = "dead_unripe"
			1:
				$sprite.animation = "dead_ripe"
			3:
				$sprite.animation = "dead_mature"

func _on_sprite_animation_finished():
	if $sprite.animation == "ripen":
		$sprite.play("ripe")
	elif $sprite.animation == "maturing":
		$sprite.play("mature")

func remove():
	remove_from_group("targets")
	destroyed.emit()
	queue_free()


func _on_poof_over():
	$poof.visible = false
