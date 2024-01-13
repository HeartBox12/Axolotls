extends State
@export var host:Node
@export var sprite:Node

func enter(): #When this state is entered
	match host.facing: #Sprite Assign
		0:
			sprite.animation = "idle_right"
		1:
			sprite.animation = "idle_down"
		2:
			sprite.animation = "idle_left"
		3:
			sprite.animation = "idle_up"
	#Change sprite to idle
	#Start playing if needed
	
func exit(): #Just before this state is exited
	pass

func update(_delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	pass

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
