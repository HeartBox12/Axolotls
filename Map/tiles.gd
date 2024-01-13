extends TileMap

var playerScene = load("res://Player/player.tscn") #Identifies the player scene, loads it
var player = playerScene.instantiate() #Identifies the player node

var turretScene = load("res://Turrets/universalTurret.tscn") #Loads up the turret template
var turrets:Array = [] #this is an array of all the turrets currently deployed, contains the direct node (use like "turrets[x].position = 64")

var bulletScene = load("res://Turrets/Projectiles/universalProjectile.tscn") #Loads the projectile
var bullets:Array = [] #array to store each turret's bullets, turrets[3] will correlate to bullets[3]

var turretPositions = 48 #temporary variable while I make sure turrets work properly

func _ready():
	game_start() #redirects to game_start() for when you lose and have to restart the game, won't have to reload the scene

func game_start(): #When the game starts, add in the player and setup the UI
	#add_child(player) #The player scene is loaded, this makes it a direct child of the tilemap
	#player.position = Vector2(48, 48) #TEMPORARY Push the player into the field
	pass

func _process(_delta):
	if Input.is_action_just_pressed("test_button_to_make_something_happen"): #we'll get rid of this control in the final version, useful for testing
		place_turret()

func place_turret():
	var tempTurret = turretScene.instantiate() #basically just throws turrets into the map
	turrets.append(tempTurret) #adds the created turret to a list for easy access
	bullets.append([])
	tempTurret.fire.connect(self.fire)
	tempTurret.index = len(turrets)-1
	add_child(turrets[len(turrets)-1]) #now the turret is an actual node!
	tempTurret.position = Vector2i(turretPositions, 48)
	turretPositions += 32

func fire(pos, rot, index):
	var shotBullet = bulletScene.instantiate()
	bullets[index].append(shotBullet)
	add_child(shotBullet)
	shotBullet.position = pos
	shotBullet.rotation = rot
	shotBullet.bulletDestroyed.connect(self.bulletDestroyed)

func bulletDestroyed():
	pass
