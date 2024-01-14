extends TileMap

var turretScene = load("res://Turrets/universalTurret.tscn") #Loads up the turret template
var turrets:Array = [] #this is an array of all the turrets currently deployed, contains the direct node (use like "turrets[x].position = 64")

var bulletScene = load("res://Turrets/Projectiles/universalProjectile.tscn") #Loads the projectile
var bullets:Array = [] #array to store each turret's bullets, turrets[3] will correlate to bullets[3]

var turretPositions = 64 #temporary variable while I make sure turrets work properly

func _ready():
	game_start() #redirects to game_start() for when you lose and have to restart the game, won't have to reload the scene

func game_start():
	#NOTE: I want to use the animationPlayer and a script in Main for this
	pass

func _process(_delta):
	#DEBUG: we'll get rid of this control in the final version, useful for testing
	if Input.is_action_just_pressed("test_button_to_make_something_happen"): 
		place_turret()

func place_turret():
	var tempTurret = turretScene.instantiate() #basically just throws turrets into the map
	turrets.append(tempTurret) #adds the created turret to a list for easy access
	bullets.append([])
	tempTurret.fire.connect(self.fire)
	tempTurret.index = len(turrets)-1
	add_child(turrets[len(turrets)-1]) #now the turret is an actual node!
	tempTurret.position = Vector2i(turretPositions, 64)
	turretPositions += 32

func fire(pos, rot, index, speed, lifetime):
	var shotBullet = bulletScene.instantiate()
	bullets[index].append(shotBullet)
	add_child(shotBullet)
	shotBullet.position = pos
	shotBullet.rotation = rot
	shotBullet.speed = speed
	shotBullet.lifetime = lifetime
	shotBullet.bulletDestroyed.connect(self.bulletDestroyed)

func bulletDestroyed():
	pass

