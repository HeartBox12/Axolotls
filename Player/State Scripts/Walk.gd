extends State
@export var host:Node
@export var sprite:Node

func enter(): #When this state is entered
	pass
	
func exit(): #Just before this state is exited
	pass

func update(delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	match host.facing: #Sprite Assign
		0:
			sprite.animation = "walk_right"
		1:
			sprite.animation = "walk_down"
		2:
			sprite.animation = "walk_left"
		3:
			sprite.animation = "walk_up"
	#Change sprite to idle
	#Start playing if needed

func physics_update(delta): #Equivalent to func physics_process() in the host.
	pass
