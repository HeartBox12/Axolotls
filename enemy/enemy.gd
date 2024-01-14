extends Area2D

@export var health:int = 5
@export var speed:int
#NOTE: not to be @export in final build
@export var target:Node #To be assigned by some no doubt terribly complicated algorithm

var onTarget = false

func _ready():
	pass

func _process(delta):
	if onTarget: #Progress the anim. Equivalent to damage.
		target.health -= delta

func _physics_process(delta):
	if !onTarget:
		global_position += global_position.direction_to(target.position) * speed * delta

#Called when the enemy is within range of a plant.
func _on_arrived(area_rid, area, area_shape_index, local_shape_index):
	target = area #Make sure to remove health from the right plant
	target.destroyed.connect(on_destroyed) #set up on_destroyed
	onTarget = true #Change behavior
	$Sprite.animation = "stomp" #change sprite to match

func on_destroyed(): #Called when the plant the enemy is attacked runs out of health
	onTarget = false
	$Sprite.animation = "walk"
	#FIXME: put in code that reassigns "target"
