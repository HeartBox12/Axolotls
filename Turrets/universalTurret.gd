extends AnimatedSprite2D
@export var fireCooldown:int = 1 #Easy access to change the cooldown period between shots, in seconds
var fireDelay:float = 0.0 #Fire delay variable, current time between shots; this is the variable that is altered
var target:Vector2 = Vector2(0, 0) #Declares the target variable and restricts it to the Vector2 data type
@export var range:int = 100 #this is the range of this turret, will only fire on targets within this range
@export var projectileSpeed:int = 1000
@export var projectileLifetime:float = 0.5
var fireRotation:float = 0
var potentialTargets = []
var currentTarget = null
var bulletScene = load("res://Turrets/Projectiles/universalProjectile.tscn") #Loads the projectile
var bullets:Array = [] #array to store each turret's bullets, turrets[3] will correlate to bullets[3]

func _ready():
	$"Range/RangeCollision".shape.radius = range
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fireRotation >= PI / 2 and fireRotation <= (3 * PI) / 2:
		flip_h = true
	else:
		flip_h = false
	if fireDelay >= 0.05 * fireCooldown and fireDelay < 0.5 * fireCooldown: #Gives leeway between firing sprite and empty sprite
		frame = 1 #Change to unloaded sprite
	elif fireDelay >= 0.5 * fireCooldown: #If halfway through the cooldown show turret as loaded
		frame = 0 #Change to loaded sprite
	var gottenTarget = getTarget()
	if typeof(gottenTarget) == typeof(null):
		return
	target = gottenTarget
	if fireDelay >= fireCooldown: #Can this turret fire? AKA is the fire cooldown done and is there a target in range?
		fireBullet() #make turrret go pew
		print("pew pew")

func _physics_process(delta):
	#target = (get_global_mouse_position() / $"/root/Main/Tiles".scale.x) #this is gonna be where the logic to find the nearest/first enemy in range goes, using mouse position for now
	fireDelay += delta #Makes fireCooldown work regardless of computer speed
	var gottenTarget = getTarget()
	if typeof(gottenTarget) == typeof(null):
		return
	target = gottenTarget
	fireRotation = target.angle_to_point(getTarget()) + PI #Gets the angle between turret and target in radians, adds 90 degrees/quarter turn

func fireBullet():
	var shotBullet = bulletScene.instantiate()
	var assignedIndex:int = 0
	var isIndexAssigned:bool = false
	frame = 2 #Change to firing sprite
	fireDelay = 0 #Resets the delay between shots
	for x in bullets:
		if !is_instance_valid(x):
			bullets[assignedIndex] = shotBullet
			isIndexAssigned = true
		assignedIndex += 1
	if !isIndexAssigned:
		bullets.append(shotBullet)
	print(bullets)
	add_child(shotBullet)
	shotBullet.rotation = fireRotation
	shotBullet.speed = projectileSpeed
	shotBullet.lifetime = projectileLifetime

func getTarget():
	if is_instance_valid(currentTarget) or currentTarget == null:
		if currentTarget in potentialTargets:
			return currentTarget.position
	if potentialTargets == []:
		return null
	var closestPosition:Vector2 = Vector2(-10000, -10000)
	var closestDistance:float = 9999999999999999
	for index in potentialTargets:
		if position.distance_to(index.position) < closestDistance:
			closestDistance = position.distance_to(index.position)
			closestPosition = index.position
			currentTarget = index
	return closestPosition

func _on_range_area_entered(area):
	potentialTargets.append(area)

func _on_range_area_exited(area):
	var areaLeft = potentialTargets.find(area)
	if areaLeft != -1:
		potentialTargets.pop_at(areaLeft)
