extends Area2D

@export var health:float = 5
var ripe = false #Read by interaction system

signal destroyed
signal picked

func _ready():
	Global.Daytime.connect(ripen)

func ripen():
	$sprite.play("ripen")
	var ripe = true

func _process(_delta):
	if health <= 0:
		remove_from_group("targets")
		destroyed.emit()
		queue_free()
