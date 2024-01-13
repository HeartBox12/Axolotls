extends AnimatedSprite2D
var fireCooldown:int = 1 #Easy access to change the cooldown period between shots, in seconds
var fireDelay:float = 0.0 #Fire delay variable, current time between shots; this is the variable that is altered
var target:Vector2 #Declares the target variable and restricts it to the Vector2 data type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = get_global_mouse_position() #this is gonna be where the logic to find the nearest/first enemy in range goes, using mouse position for now
	if fireDelay >= 0.05 * fireCooldown and fireDelay < 0.5 * fireCooldown: #Gives leeway between firing sprite and empty sprite
		frame = 1 #Change to unloaded sprite
	elif fireDelay >= 0.5 * fireCooldown: #If halfway through the cooldown show turret as loaded
		frame = 0 #Change to loaded sprite
	fireDelay += delta #Makes fireCooldown work regardless of computer speed
	if fireDelay >= fireCooldown and position.distance_to(target) <= 100: #Can this turret fire? AKA is the fire cooldown done and is there a target in range?
		fireBullet() #make turrret go pew

func _physics_process(delta):
	rotation = target.angle_to_point(position) + 1.570796 #Gets the angle between turret and target in radians, adds 90 degrees/quarter turn
#to future me: change the sprites to default face right so there doesn't need to be an angle offset

func fireBullet():
	frame = 2 #Change to firing sprite
	print("pew pew pew") #Projectile firing goes here
	fireDelay = 0 #Resets the delay between shots
