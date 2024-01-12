extends State
@export var host:Node

func enter(): #When this state is entered
	match host.facing: #Sprite Assign, might need more if sprites are octal
		0:
			pass #Up-facing sprite
		1:
			pass
		2:
			pass
		3:
			pass
	#Change sprite to idle
	#Start playing if needed
	
func exit(): #Just before this state is exited
	pass

func update(delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	pass

func physics_update(delta): #Equivalent to func physics_process() in the host.
	pass
