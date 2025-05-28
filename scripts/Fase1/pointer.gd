# pointer.gd
extends Area2D

@export var speed := 200.0 # É bom usar float para velocidade se delta for float
@export var min_x := -320.0
@export var max_x := 300.0
var direction: int = 1 # int é suficiente para -1 ou 1

# Variável para guardar a posição inicial para o reset
var initial_x_position: float

func _ready():
	# Guardar a posição inicial (ou definir uma padrão)
	initial_x_position = min_x # Por padrão, começa na borda esquerda
	position.x = initial_x_position

func _process(delta: float): # É bom tipar delta como float
	position.x += speed * direction * delta

	if position.x >= max_x:
		position.x = max_x
		direction = -1
	elif position.x <= min_x:
		position.x = min_x
		direction = 1

func reset_pointer_position():
	position.x = initial_x_position
	direction = 1 # Garante que comece movendo para a direita (ou conforme sua lógica)
