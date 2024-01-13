extends Node2D
var day = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Win")

func adjust_day():
	$DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[day]
	$DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] %s days[/color][/center]"%[day]

func start_day():
	pass
