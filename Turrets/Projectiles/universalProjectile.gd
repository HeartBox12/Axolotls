extends Area2D
var direction
var speed:int = 50 #how fast does the projectile go? in pixels/second
var lifetime:float = 2.0 #how many seconds does the projectile say alive for
var currentLife:float = 0.0 #current time it's been alive for
var damage:int = 1
var animationTime:float = 0
@onready var sprite = $"CollisionShape2D/Sprite2D"
var texture = load("res://Assets/limer_splat.png")
var splatting:bool = false
var areaHit
var hitOffset

func _ready():
	position = Vector2(0,0)

func _physics_process(delta):
	if !splatting:
		currentLife += delta #makes sure that the projectile dies when it's lifetime is over
		if currentLife >= lifetime:
			queue_free() #destroy this node after this frame
		direction = global_transform.basis_xform(Vector2.RIGHT) #gets a vector direction based on the rotation
		position += direction * delta * speed #what it says on the tin; makes it move in the proper direction according to delta and speed
	if splatting:
		animationTime += delta
		position = areaHit.position - hitOffset
	if animationTime >= 0.2:
		queue_free()

func _on_area_entered(area):
	areaHit = area
	hitOffset = areaHit.position - position
	areaHit.health -= damage
	splatAnimation()

func splatAnimation():
	splatting = true
	sprite.texture = texture
