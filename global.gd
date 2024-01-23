extends Node

signal Daytime
signal Nighttime

var limes:int = 2
var seeds:int = 3
var plantCost = 1 #in seeds

var turretPrices = [1, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 5]
var turrPriceInd = 0

func playSound(sfxNode, changePitch:bool = true):
	if sfxNode is Array:
		sfxNode = sfxNode[randi_range(0, len(sfxNode) - 1)]
	if changePitch:
		var pitch = randf_range(0.9, 1.1)
		sfxNode.pitch_scale = pitch
	sfxNode.play()
