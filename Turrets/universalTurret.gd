extends AnimatedSprite2D
@export var fireCooldown:int = 1 #Easy access to change the cooldown period between shots, in seconds
var fireDelay:float = 1 #Fire delay variable, current time between shots; this is the variable that is altered
var target:Vector2 = Vector2(0, 0) #Declares the target variable and restricts it to the Vector2 data type
@export var fireRange:int = 200 #this is the range of this turret, will only fire on targets within this range
@export var projectileSpeed:int = 1000
@export var projectileLifetime:float = 0.25
@export var projectileDamage:int = 1
var fireRotation:float = 0
var potentialTargets = []
var currentTarget = null
var bulletScene = load("res://Turrets/Projectiles/universalProjectile.tscn") #Loads the projectile
var bullets:Array = [] #array to store each turret's bullets, turrets[3] will correlate to bullets[3]

func _ready():
	frame = 0
	$"Range/RangeCollision".shape.radius = fireRange
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fireRotation >= PI / 2 and fireRotation <= (3 * PI) / 2: #flip horizontally according to where it's target is
		flip_h = true
	else:
		flip_h = false
	if fireDelay >= 0.05 * fireCooldown and fireDelay < 0.5 * fireCooldown: #Gives leeway between firing sprite and empty sprite
		frame = 1 #Change to unloaded sprite
	elif fireDelay >= 0.5 * fireCooldown: #If halfway through the cooldown show turret as loaded
		frame = 0 #Change to loaded sprite

func _physics_process(delta):
	fireDelay += delta #Makes fireCooldown work regardless of computer speed
	var gottenTarget = getTarget()
	if typeof(gottenTarget) == typeof(null): #check if there is an enemy to be targeted
		return #if no enemies, don't calculate a target
	target = gottenTarget
	fireRotation = global_position.angle_to_point(getTarget()) #Gets the angle between turret and target in radians, adds 90 degrees/quarter turn
	if fireDelay >= fireCooldown: #Can this turret fire? AKA is the fire cooldown done and is there a target in range?
		fireBullet() #make turrret go pew

func fireBullet():
	var shotBullet = bulletScene.instantiate()
	var assignedIndex:int = 0
	var isIndexAssigned:bool = false
	frame = 2 #Change to firing sprite
	fireDelay = 0 #Resets the delay between shots
	for x in bullets: #this for loop checks if any bullets have been destroyed yet, replaces if so
		if !is_instance_valid(x):
			bullets[assignedIndex] = shotBullet
			isIndexAssigned = true
		assignedIndex += 1
	if !isIndexAssigned:
		bullets.append(shotBullet) #if no bullets have been destroyed, append instead
	add_child(shotBullet)
	shotBullet.rotation = fireRotation #all this just sets the bullet stats
	shotBullet.speed = projectileSpeed
	shotBullet.lifetime = projectileLifetime
	shotBullet.global_position = global_position
	shotBullet.damage = projectileDamage
	
	$gunsnd_1.play()

func getTarget():
	if is_instance_valid(currentTarget) or currentTarget == null: #if the current target exists
		if currentTarget in potentialTargets: #if the current target is in range
			return currentTarget.global_position #stay on the current target
	if potentialTargets == []: #if there are no enemies in range, don't calculate closest enemy
		return null
	var closestPosition:Vector2 = Vector2(-10000, -10000) #if the current target has left range or has died, calculate new target
	var closestDistance:float = 9999999999999999 #these numbers are intentionally huge, otherwise it doesn't matter
	for index in potentialTargets: #go through all potential targets and find the closest
		if global_position.distance_to(index.global_position) < closestDistance:
			closestDistance = global_position.distance_to(index.global_position) #update closest enemy to new closest
			closestPosition = index.global_position
			currentTarget = index
	return closestPosition #return the new target

func _on_range_area_entered(area): #keep track of enemies in range, add an enemy to potential targets if entered range
	potentialTargets.append(area)

func _on_range_area_exited(area): #keep track of enemies in range, remove them from potential targets if out of range
	var areaLeft = potentialTargets.find(area)
	if areaLeft != -1:
		potentialTargets.pop_at(areaLeft) #remove the enemy that left range from targets

func remove():
	queue_free() #This is only here so I can remove it the same way one removes a plant
