# timing_bar.gd
extends Node2D

@onready var marker: Area2D = $Marker
@onready var pointer: Area2D = $Pointer # Referência ao pointer

# Defina os limites (coordenadas X) onde a marcação pode aparecer.
# Ajuste estes valores para que a marcação fique dentro da sua barra visual.
# Estes valores são relativos à posição do nó timing_bar (Node2D).
@export var marker_min_x_pos: float = -205.5 # Exemplo: Borda esquerda da área útil da barra
@export var marker_max_x_pos: float = 205.5 # Exemplo: Borda direita da área útil da barra

# Sinal para comunicar o resultado para a fase (opcional, mas recomendado)
signal minigame_completed(success: bool)

func _ready():
	# Garante que o gerador de números aleatórios seja inicializado
	# random_number_generator.randomize() # No Godot 4.x, randomize() é chamado automaticamente.
										# No Godot 3.x, use randomize()
	pass

# Função para ser chamada quando o minigame deve começar/reiniciar
func start_minigame():
	# 1. Randomizar a posição X do Marker
	var random_x = randf_range(marker_min_x_pos, marker_max_x_pos)
	marker.position.x = random_x
	
	# 2. Opcional: Resetar a posição do Pointer para o início
	if pointer.has_method("reset_pointer_position"):
		pointer.call("reset_pointer_position")
	else:
		# Fallback se o método não existir (ajuste conforme a lógica do seu pointer.gd)
		pointer.position.x = pointer.min_x # Usa o min_x definido no pointer.gd
		pointer.direction = 1
		
	self.visible = true
	print("Minigame iniciado. Marcacao em x:", marker.position.x)

func _on_Confirmar_pressed():
	var overlapping_areas = $Pointer.get_overlapping_areas()
	var success = false
	if $Marker in overlapping_areas:
		print("Acertou!")
		success = true
	else:
		print("Errou!")
		success = false
	
	emit_signal("minigame_completed", success)
	self.visible = false # Esconde a barra após a tentativa
