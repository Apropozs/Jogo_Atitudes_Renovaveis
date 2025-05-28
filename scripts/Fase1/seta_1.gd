# Script anexado à sua Seta (Sprite2D)
extends Sprite2D

@export var altura_pulso: float = 15.0 # O quanto a seta vai subir/descer
@export var duracao_pulso: float = 0.5 # Duração de um ciclo (subir ou descer)

func _ready():
	animar_seta()

func animar_seta():
	var tween = get_tree().create_tween()
	tween.set_loops() # Para repetir indefinidamente

	# Anima para cima
	tween.tween_property(self, "position:y", position.y - altura_pulso, duracao_pulso)\
		 .set_trans(Tween.TRANS_SINE)\
		 .set_ease(Tween.EASE_IN_OUT)

	# Anima para baixo
	tween.tween_property(self, "position:y", position.y, duracao_pulso)\
		 .set_trans(Tween.TRANS_SINE)\
		 .set_ease(Tween.EASE_IN_OUT)

	# Se quiser que o tween comece imediatamente, não precisa de play() explícito
	# a menos que você crie o tween com .stop() e depois queira iniciar.
