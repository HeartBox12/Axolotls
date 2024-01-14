extends Area2D

@export var health:float = 5
var ripe = false

func ripen():
	$sprite.play("ripen")
	var ripe = true
