extends Control

@onready var nome_input = $InformarNome  # LineEdit
@onready var confirmar_button = $ConfirmarButton


var nome_jogador = ""  # Aqui vamos guardar o nome

func _on_Voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_config_pressed() -> void:
	pass
	#get_tree().change_scene_to_file("res://scenes/Configuracoes.tscn")

func _on_confirmar_pressed() -> void:
	nome_jogador = nome_input.text.strip_edges()  # Remove espaços em branco

	if nome_jogador.is_empty():
		# Opcional: mostrar uma mensagem para o jogador
		print("Digite um nome antes de continuar.")
		return

	# Salvar o nome globalmente, se quiser
	Global.nome_jogador = nome_jogador  # Se você tiver um singleton Global.gd

	# Trocar para a cena de fases
	get_tree().change_scene_to_file("res://scenes/MenuFases.tscn")
