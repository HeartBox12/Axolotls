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

#These arrays track how many of each type of enemy is set to spawn where each night.
var torchforkSpawns = [2, 2, 2]
var picketerSpawns = [0, 0, 0]
var FBISpawns = [0, 0, 0]

func _ready():
	Global.Nighttime.connect(_on_night)

func _process(_delta):
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
	enemy.position = follow.position
	get_parent().add_child(enemy)
	enemy.death.connect(Callable(get_parent(), "_enemy_down"))
	get_parent().clear.connect(Callable(enemy, "_on_clear"))

func _on_night(): #called by Global.Nighttime
	if torchforkSpawns[0] > 0:
		$leftTimer.start() #leftTimer is connected to left_spawn_time()
	if torchforkSpawns[1] > 0:
		$bottomTimer.start()
	if torchforkSpawns[2] > 0:
		$rightTimer.start()
	
func _left_spawn_time(): #Called by leftTimer timing out
	torchforkSpawns[0] -= 1
	if torchforkSpawns[0] <= 0:
		$leftTimer.stop()
	setSide("left")
	#FIXME: set to spawn any FBI or protesters
	
func _bottom_spawn_time(): #Called by leftTimer timing out
	torchforkSpawns[1] -= 1
	if torchforkSpawns[1] <= 0:
		$bottomTimer.stop()
	setSide("bottom")
	#FIXME: set to spawn any FBI or protesters
	
func _right_spawn_time(): #Called by leftTimer timing out
	torchforkSpawns[2] -= 1
	if torchforkSpawns[2] <= 0:
		$rightTimer.stop()
	setSide("right")
	#FIXME: set to spawn any FBI or protesters
