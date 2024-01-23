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
#var PSbase = [load("res://enemy/enemyPitchfork.tscn"), load("res://enemy/enemyProtestor.tscn"), load("res://enemy/enemyFBI.tscn")]
var E1 = preload("res://enemy/enemyProtestor.tscn")
var E2 = preload("res://enemy/enemyPitchfork.tscn")
var E3 = preload("res://enemy/enemyFBI.tscn")

var enemyLineProgress:float = randi_range(0, 1)
var enemy
var side
var follow

var leftSpawns = [E1, E1]
var bottomSpawns = [E1, E1, E1]
var rightSpawns = [E1]

func _ready():
	Global.Nighttime.connect(_on_night)
	Global.Daytime.connect(populateSpawns)

#func _process(_delta): #We need to remove this.
	#if Input.is_action_just_pressed("test4"):
		#setSide("left", PSbase[2])
	#if Input.is_action_just_pressed("test2"):
		#setSide("bottom", PSbase[1])
	#if Input.is_action_just_pressed("test6"):
		#setSide("right", E1)

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
			leftSpawns = [E1]
			bottomSpawns = [E1, E1]
			rightSpawns = [E1]
		1:
			leftSpawns = [E1, E2]
			bottomSpawns = [E1, E1]
			rightSpawns = [E1, E2]
		2:
			leftSpawns = [E1, E1]
			bottomSpawns = [E1, E1, E2, E2, E2, E2, E2]
			rightSpawns = [E1, E1]
		3:
			leftSpawns = [E1, E2, E2, E1]
			bottomSpawns = [E2, E1, E1, E1, E2]
			rightSpawns = [E1, E2, E2, E1, E1, E1, E3, E3]
		4:
			leftSpawns = [E2, E1, E1, E2, E1, E3, E3, E2, E3, E2]
			bottomSpawns = [E1, E2, E1, E1, E2, E1, E2, E3, E2, E3]
			rightSpawns = [E1, E3, E2, E1, E1, E3, E2, E2, E2, E2]
