extends Node
class_name State #Allows script to be Extended

#For changing states. Emit with the new state's name as string param.
#NOTE: will result in the exit() function being called.
signal swap #Call with swap.emit(self, "<name>")
#Self param may be avoided by using SM's currentState variable. Consider for future builds.

func enter(): #When something enters the state
	pass
	
func exit(): #When something moves into another state having previously been in this one
	pass
	
func update(_delta:float): #Stand-in for process
	pass

func physics_update(_delta:float): #Stand-in for Physics_process
	pass
