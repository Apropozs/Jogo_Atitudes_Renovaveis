# PainelSolarBotao.gd
extends Button

# Assumindo que o nó da seta filha se chama "SetaIndicadora"
# Ajuste o nome se for diferente na sua cena da placa/botão.
@onready var seta_indicadora: Node2D = $seta4
@onready var textura_placa_instalada: TextureRect = $placa_texture 

var is_installed: bool = false

func _ready():
	# Garante que o estado visual inicial esteja correto
	if is_installed:
		_atualizar_visual_instalado()
	else:
		_atualizar_visual_nao_instalado()

func _atualizar_visual_instalado():
	if seta_indicadora:
		seta_indicadora.hide()
		if seta_indicadora.has_node("AnimationPlayer"):
			seta_indicadora.get_node("AnimationPlayer").stop()
	if textura_placa_instalada:
		textura_placa_instalada.visible = true
	self.disabled = true # Desabilita o botão para não ser clicado novamente
	# Você pode adicionar mais mudanças visuais aqui (ex: mudar textura do botão)
	# self.text = "Instalado" # Se for um botão com texto

func _atualizar_visual_nao_instalado():
	if seta_indicadora:
		seta_indicadora.show()
		if seta_indicadora.has_node("AnimationPlayer"):
			var anim_player = seta_indicadora.get_node("AnimationPlayer")
			# Garante que a animação correta esteja tocando
			# Se você configurou "Autoplay" no AnimationPlayer, isso pode não ser necessário,
			# mas é uma boa garantia.
			var anim_name_to_play = anim_player.autoplay
			if anim_name_to_play == "" and anim_player.has_animation("SetaPulsando"): # Use o nome da sua animação
				anim_name_to_play = "SetaPulsando"
			if anim_name_to_play != "" and not anim_player.is_playing():
				anim_player.play(anim_name_to_play)
	if textura_placa_instalada:
		textura_placa_instalada.visible = false

	self.disabled = false

# Esta função será chamada pelo fase1.gd
func instalar():
	if not is_installed:
		is_installed = true
		_atualizar_visual_instalado()
		print(self.name + " foi instalado.")

# Esta função pode ser usada pelo fase1.gd para checar o estado
func esta_instalado() -> bool:
	return is_installed
