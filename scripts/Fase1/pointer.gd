extends Area2D

@export var speed := 200
@export var min_x := -320
@export var max_x := 300
var direction := 1


func _process(delta):

	position.x += speed * direction * delta

	if position.x >= max_x:
		position.x = max_x
		direction = -1
	elif position.x <= min_x:
		position.x = min_x
		direction = 1
