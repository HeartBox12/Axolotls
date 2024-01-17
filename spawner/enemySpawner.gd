extends Node2D
@onready var leftSpawn = $"LeftSpawn"
@onready var leftFollow = $"LeftSpawn/Follow"
@onready var rightSpawn = $"RightSpawn"
@onready var rightFollow = $"RightSpawn/Follow"
@onready var bottomSpawn = $"BottomSpawn"
@onready var bottomFollow = $"BottomSpawn/Follow"
#@onready var tileMap = $"/root/Main/Tiles" #is this needed?

#For the sake of code brevity, enemy_scene was renamed PSbase. 
#Future enemy PackedScenes should be given the prefix of PS and the shortest possible descriptor.
#We should consider using integers.
var PSbase = load("res://enemy/enemy.tscn")
var enemyLineProgress:float = randi_range(0, 1)
var enemy
var side
var follow

var leftSpawns = [PSbase, PSbase]
var bottomSpawns = [PSbase, PSbase, PSbase]
var rightSpawns = [PSbase]

func _ready():
	Global.Nighttime.connect(_on_night)
	Global.Daytime.connect(populateSpawns)

func _process(_delta):
	if Input.is_action_just_pressed("test4"):
		setSide("left", PSbase)
	if Input.is_action_just_pressed("test2"):
		setSide("bottom", PSbase)
	if Input.is_action_just_pressed("test6"):
		setSide("right", PSbase)

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
	if bottomSpawns.is_empty():
		$bottomTimer.stop()
	#FIXME: set to spawn any FBI or protesters
	
func _right_spawn_time(): #Called by leftTimer timing out
	setSide("right", rightSpawns.pop_front())
	if rightSpawns.is_empty():
		$rightTimer.stop()
	#FIXME: set to spawn any FBI or protesters

#---- FROM THIS POINT FORWARD YOU ENTER THE DOMAIN OF THE DAMNED ----#

#For the love of GOD, please put some really short variable names for PackedScenes
func populateSpawns():
	match get_parent().day:
		0:
			leftSpawns = [PSbase]
			bottomSpawns = [PSbase, PSbase]
			rightSpawns = [PSbase]
		1:
			leftSpawns = [PSbase, PSbase]
			bottomSpawns = [PSbase, PSbase]
			rightSpawns = [PSbase, PSbase]
		2:
			leftSpawns = [PSbase, PSbase]
			bottomSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
			rightSpawns = [PSbase, PSbase]
		3:
			leftSpawns = [PSbase, PSbase, PSbase, PSbase]
			bottomSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase]
			rightSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
		4:
			leftSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
			bottomSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase]
			rightSpawns = [PSbase, PSbase, PSbase, PSbase]
		5:
			leftSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
			bottomSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
			rightSpawns = [PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase, PSbase]
