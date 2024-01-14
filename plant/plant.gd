extends Area2D

@export var health:float = 5
var ripe = false #Read by interaction system

signal picked
signal destroyed

func _ready():
	Global.Daytime.connect(ripen)

func ripen():
	$sprite.play("ripen")
	var ripe = true

func _process(delta):
	if health <= 0:
		queue_free()
