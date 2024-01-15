extends TileMap

var turretScene = load("res://Turrets/universalTurret.tscn") #Loads up the turret template
var turrets:Array = [] #this is an array of all the turrets currently deployed, contains the direct node (use like "turrets[x].position = 64")

var turretPositions = 64 #temporary variable while I make sure turrets work properly

func _ready():
	game_start() #redirects to game_start() for when you lose and have to restart the game, won't have to reload the scene

func game_start():
	#NOTE: I want to use the animationPlayer and a script in Main for this
	pass

func _process(_delta):
	pass
	#DEBUG: we'll get rid of this control in the final version, useful for testing
	#if Input.is_action_just_pressed("left click"):
	#	place_turret(get_global_mouse_position())
#	if Input.is_action_just_pressed("test_button_to_make_something_happen"): 
#		place_turret()

func place_turret(placement):
	var assignedIndex:int = 0
	var isIndexAssigned:bool = false
	var tempTurret = turretScene.instantiate() #basically just throws turrets into the map
	for x in turrets:
		if !is_instance_valid(x):
			turrets[assignedIndex] = tempTurret
			isIndexAssigned = true
		assignedIndex += 1
	if !isIndexAssigned:
		turrets.append(tempTurret)
	add_child(tempTurret)
	tempTurret.position = placement
#	tempTurret.position = Vector2i(turretPositions, 300)
#	turretPositions += 32

func bulletDestroyed():
	pass

