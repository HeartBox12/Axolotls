extends TileMap

var playerScene = load("res://Player/player.tscn") #Identifies the player scene, loads it
var player = playerScene.instantiate() #Identifies the player node

var turretScene = load("res://Turrets/universalTurret.tscn") #Loads up the turret template
var turrets:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	game_start()

func game_start(): #When the game starts, add in the player and setup the UI
	add_child(player) #The player scene is loaded, this makes it a direct child of the tilemap
	player.position = Vector2(48, 48) #TEMPORARY Push the player into the field

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var turretPositions = 100
	if Input.is_action_just_pressed("test_button_to_make_something_happen"):
		var tempTurret = turretScene.instantiate()
		turrets.append(tempTurret)
		add_child(turrets[len(turrets)-1])
		for x in turrets:
			print(x.position)
			x.position = Vector2i(turretPositions, 100)
			turretPositions += 32
