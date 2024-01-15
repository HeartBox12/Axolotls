extends Area2D
var direction
@export var speed:int #how fast does the projectile go? in pixels/second
@export var lifetime:float #how many seconds does the projectile say alive for
var currentLife:float = 0.0 #current time it's been alive for

func _physics_process(delta):
	currentLife += delta #makes sure that the projectile dies when it's lifetime is over
	if currentLife >= lifetime:
		queue_free() #destroy this node after this frame
	direction = global_transform.basis_xform(Vector2.RIGHT) #gets a vector direction based on the rotation
	position += direction * delta * speed #what it says on the tin; makes it move in the proper direction according to delta and speed
