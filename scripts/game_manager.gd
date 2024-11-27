extends Node

var score = 0
var can_jetpack = false

func add_point():
	score += 1
	print("Added one point")
	
func go_back_to_level_1():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	can_jetpack = false
