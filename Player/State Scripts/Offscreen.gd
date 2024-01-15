extends State
@export var host:Node
@export var machine:Node

func enter(): #When this state is entered
	host.visible = false
	host.coordSelect.emit(Vector2i(-1, -1))
	
func exit(): #Just before this state is exited
	host.visible = true
	host.facing = 1

func update(_delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	pass

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
