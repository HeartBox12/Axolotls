extends Node2D
@onready var leftSpawn = $"LeftSpawn"
@onready var rightSpawn = $"RightSpawn"
@onready var bottomSpawn = $"BottomSpawn"
var enemyLineProgress:float = randi_range(0, 1)

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("test4"):
		spawnEnemy("left")
	if Input.is_action_just_pressed("test2"):
		spawnEnemy("bottom")
	if Input.is_action_just_pressed("test6"):
		spawnEnemy("right")

func spawnEnemy(side):
	if side == "left":
		side = leftSpawn
	if side == "bottom":
		side = bottomSpawn
	if side == "right":
		side = rightSpawn
