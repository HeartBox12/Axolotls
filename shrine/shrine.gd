extends Area2D

var health = 10

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Daytime.connect(_on_daytime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health <= 0:
		destroyed.emit()
		health = 10

func _on_daytime():
	health = 10
