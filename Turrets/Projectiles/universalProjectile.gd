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
	global_position = Vector2(0,0)

func _physics_process(delta):
	if !splatting: #has not yet hit an enemy
		currentLife += delta #makes sure that the projectile dies when it's lifetime is over
		if currentLife >= lifetime:
			queue_free() #destroy this node after this frame
		direction = global_transform.basis_xform(Vector2.RIGHT) #gets a vector direction based on the rotation
		global_position += direction * delta * speed #what it says on the tin; makes it move in the proper direction according to delta and speed
	if splatting:
		animationTime += delta
		if is_instance_valid(areaHit): #does the enemy still exist
			global_position = areaHit.global_position - hitOffset #stick to the enemy after projectile hits
		else:
			queue_free() #free scene if enemy is gone
	if animationTime >= 0.2: #0.2 is the time in seconds it takes the splat "animation"
		queue_free()

func _on_area_entered(area):
	areaHit = area
	hitOffset = areaHit.global_position - global_position #find where to stick to enemy after hit
	areaHit.health -= damage #hurt the enemy
	splatAnimation() #begin the splat timer

func splatAnimation():
	splatting = true
	sprite.texture = texture
	$hitsnd_3.play()
