extends State

func enter(): #When this state is entered
	pass
	
func exit(): #Just before this state is exited
	pass

func update(delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	pass

func physics_update(delta): #Equivalent to func physics_process() in the host.
	pass
