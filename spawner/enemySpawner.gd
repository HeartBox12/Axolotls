extends Node2D
@onready var leftSpawn = $"LeftSpawn"
@onready var leftFollow = $"LeftSpawn/Follow"
@onready var rightSpawn = $"RightSpawn"
@onready var rightFollow = $"RightSpawn/Follow"
@onready var bottomSpawn = $"BottomSpawn"
@onready var bottomFollow = $"BottomSpawn/Follow"
#@onready var tileMap = $"/root/Main/Tiles" #is this needed?
var enemy_scene = load("res://enemy/enemy.tscn")
var enemyLineProgress:float = randi_range(0, 1)
var enemy
var side
var follow

var leftSpawns = [enemy_scene, enemy_scene]
var bottomSpawns = []
var rightSpawns = []

func _ready():
	Global.Nighttime.connect(_on_night)

func _process(_delta):
	if Input.is_action_just_pressed("test4"):
		setSide("left", enemy_scene)
	if Input.is_action_just_pressed("test2"):
		setSide("bottom", enemy_scene)
	if Input.is_action_just_pressed("test6"):
		setSide("right", enemy_scene)

func setSide(button, instanceScene:PackedScene):
	if button == "left":
		side = leftSpawn
		follow = leftFollow
	if button == "bottom":
		side = bottomSpawn
		follow = bottomFollow
	if button == "right":
		side = rightSpawn
		follow = rightFollow
	spawnEnemy(instanceScene)

func spawnEnemy(instanceScene:PackedScene):
	follow.progress_ratio = randf_range(0, 1)
	enemy = instanceScene.instantiate()
	enemy.position = follow.position
	get_parent().add_child(enemy)
	enemy.death.connect(Callable(get_parent(), "_enemy_down"))
	get_parent().clear.connect(Callable(enemy, "_on_clear"))
	
	get_parent().enemArray.append(enemy)

func _on_night(): #called by Global.Nighttime
	if !leftSpawns.is_empty():
		$leftTimer.start() #leftTimer is connected to left_spawn_time()
	if !bottomSpawns.is_empty():
		$bottomTimer.start()
	if !rightSpawns.is_empty():
		$rightTimer.start()
	
func _left_spawn_time(): #Called by leftTimer timing out
	setSide("left", leftSpawns.pop_front())
	if leftSpawns.is_empty():
		$leftTimer.stop()
	#FIXME: set to spawn any FBI or protesters
	
func _bottom_spawn_time(): #Called by leftTimer timing out
	setSide("bottom", bottomSpawns.pop_front())
	if leftSpawns.is_empty():
		$rightTimer.stop()
	#FIXME: set to spawn any FBI or protesters
	
func _right_spawn_time(): #Called by leftTimer timing out
	setSide("right", rightSpawns.pop_front())
	if rightSpawns.is_empty():
		$rightTimer.stop()
	#FIXME: set to spawn any FBI or protesters
