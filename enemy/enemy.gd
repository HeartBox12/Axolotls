extends Area2D

@export var health:int = 5
@export var speed:int

var target:Node

var onTarget = false

#Find the closest thing and prepare to approach
func _ready():
	find_target()

func find_target():
	target = null
	var prospects = get_tree().get_nodes_in_group("targets") #Returns node array
	if prospects.is_empty():
		print("No targets found!")
		queue_free()
	#But if there are targets...
	var closest = 100000 #Arbitrarily large value
	for i in prospects: #Iterate to find closest
		if position.distance_to(i.position) < closest:
			closest = position.distance_to(i.position)
			target = i

func _process(delta):
	if onTarget: #Progress the anim. Equivalent to damage.
		target.health -= delta

func _physics_process(delta):
	if !onTarget && target != null:
		global_position += global_position.direction_to(target.position) * speed * delta

#Called when the enemy is within range of a plant.
func _on_arrived(area_rid, area, area_shape_index, local_shape_index):
	target = area #Make sure to remove health from the right plant
	target.destroyed.connect(on_destroyed) #set up on_destroyed
	onTarget = true #Change behavior
	$Sprite.animation = "stomp" #change sprite to match

func on_destroyed(): #Called when the plant the enemy is attacked runs out of health
	onTarget = false
	target = null
	$Sprite.animation = "walk"
	find_target()
