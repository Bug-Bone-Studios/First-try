extends Area2D

var moving_up = true
var original_position: Vector2  # Grab position
var move_amount = 5  # Set how far it moves up and down
var is_active = true  # Track if the item is active (not picked up)

@onready var label: Label = $"../Pedestal/Label"

func _ready() -> void:
	original_position = position  # Initialize original_position to the object's starting position

func _on_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		print("Jetpack added")
		_body.can_jetpack = true
		GameManager.can_jetpack = true
		is_active = false 
		label.text = "JETPACK AQUIRED 
		🔼 TO USE"
		queue_free()  # Remove the jetpack item after pickup	
	
func _process(delta: float) -> void:
	if is_active:
		if moving_up:
			position.y -= 5 * delta  # Move up
			if position.y <= original_position.y - move_amount:
				moving_up = false  # Change direction
		else:
			position.y += 5 * delta  # Move down
			if position.y >= original_position.y:
				moving_up = true  # Change direction
