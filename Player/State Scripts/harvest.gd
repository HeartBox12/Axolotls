extends State
@export var host:Node
@export var machine:Node
@export var clock:Node
@export var riser:Node
@export var text:Node
@export var dig1:Node
@export var dig2:Node
@export var dig3:Node
@export var dig4:Node

@export var wait_time:int

var digs:int = 0

func enter(): #When this state is entered
	clock.max_value = wait_time
	clock.value = 0
	clock.visible = true
	Global.playSound(riser, false)
	
	text.visible = true
	text.text = "[center]Harvesting...[/center]"
	
func exit(): #Just before this state is exited
	clock.visible = false
	riser.stop()
	
	text.visible = false
	text.text = ""

func update(delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	if host.input != Vector2(0, 0):
		swap.emit(self, "walk")
	
	if clock.value >= digs * 0.7:
		digs += 1
		Global.playSound([dig1, dig2, dig3, dig4])
	clock.value += delta
	if clock.value >= clock.max_value:
		host.harvested.emit(host.selPos)
		swap.emit(self, "idle")

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
