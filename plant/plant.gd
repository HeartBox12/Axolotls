extends Area2D

@export var health:float = 5
var profit = 0 #The current number of limes

signal destroyed
signal picked

func _ready():
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
		remove_from_group("targets")
		destroyed.emit()
		queue_free()

func _on_sprite_animation_finished():
	if $sprite.animation == "ripen":
		$sprite.play("ripe")
	elif $sprite.animation == "maturing":
		$sprite.play("mature")
