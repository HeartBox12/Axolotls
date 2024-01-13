extends Node

var currentState:State
var states:Dictionary = {}

@export var initState:State

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children(): #For each node-child...
		if node is State: #If it belongs to the State class...
			states[node.name.to_lower()] = node #Add it to the enumeration under it's node-name as string
			node.swap.connect(on_swap) #Set it up to swap states cleanly.
	
	if initState:
		currentState = initState
		initState.enter()
	
func _process(delta): #Frame-to-frame behavior is dictated by the state
	currentState.update(delta)

func _physics_process(delta): #Physics interactions are dictated by the state
	currentState.physics_update(delta)
#Any more things dictated by the state and we'll have a dystopian novel 

func on_swap(curr:State, newName:StringName): #Curr = current state. New = incoming state's name
	var newState = states.get(newName.to_lower()) #Reference to the node itself, instead of StringName
	if !curr || curr != currentState || !newState: #Validity checks
		print("Invalid call to on_swap in State Machine!") #Error check
		return
		
	curr.exit()
	currentState = newState #Refactor later and just use currentState. NOTE: this will not be compatible with checks
	newState.enter()
