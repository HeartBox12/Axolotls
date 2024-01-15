extends Node2D
@onready var leftSpawn = $"LeftSpawn"
@onready var leftFollow = $"LeftSpawn/Follow"
@onready var rightSpawn = $"RightSpawn"
@onready var rightFollow = $"RightSpawn/Follow"
@onready var bottomSpawn = $"BottomSpawn"
@onready var bottomFollow = $"BottomSpawn/Follow"
@onready var tileMap = $"/root/Main/Tiles"
var enemy_scene = load("res://enemy/enemy.tscn")
var enemyLineProgress:float = randi_range(0, 1)
var enemy
var side
var follow

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("test4"):
		setSide("left")
	if Input.is_action_just_pressed("test2"):
		setSide("bottom")
	if Input.is_action_just_pressed("test6"):
		setSide("right")

func setSide(button):
	if button == "left":
		side = leftSpawn
		follow = leftFollow
	if button == "bottom":
		side = bottomSpawn
		follow = bottomFollow
	if button == "right":
		side = rightSpawn
		follow = rightFollow
	spawnEnemy()

func spawnEnemy():
	follow.progress_ratio = randf_range(0, 1)
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.position = follow.position
	get_parent().clear.connect(Callable(enemy, "_on_clear"))
