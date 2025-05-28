# fase1.gd
extends Control

## -------------------- EXPORTS E CONSTANTES -------------------- ##
const MAX_PLACAS_PARA_INSTALAR: int = 4
const MAX_ERROS_POR_TENTATIVA_NA_PLACA: int = 2
const VIDAS_INICIAIS: int = 4

## -------------------- REFERÊNCIAS DE NÓS (@onready) -------------------- ##
# Referência à barra de timing
@onready var timingBar = $timingBar # Ajuste o nome/caminho se necessário

# Referências aos TextureRects dos corações (vidas)
# Ajuste os caminhos se não forem filhos diretos deste nó
@onready var coracao1: TextureRect = $coracao1
@onready var coracao2: TextureRect = $coracao2
@onready var coracao3: TextureRect = $coracao3
@onready var coracao4: TextureRect = $coracao4

# Referências às placas (botões) - Opcional aqui se já conectar sinais
# e obtiver a referência no método _on_PlacaX_pressed
# Ex: @onready var placa_btn_1: Button = $Placa1

## -------------------- VARIÁVEIS DE ESTADO DO JOGO -------------------- ##
var array_coracoes: Array[TextureRect]
var vidas_atuais: int = VIDAS_INICIAIS
var placas_instaladas: int = 0

var placa_solar_ativa_no_minigame = null # Guarda o nó da placa sendo jogada
var erros_na_tentativa_atual_da_placa: int = 0 # Erros na sequência para a placa_solar_ativa_no_minigame


## -------------------- FUNÇÕES DO GODOT (ENGINE CALLBACKS) -------------------- ##
func _ready() -> void:
	# Configura a barra de timing
	if timingBar:
		timingBar.visible = false
		# Conecta o sinal da timingBar a uma função deste script
		if not timingBar.is_connected("minigame_completed", Callable(self, "_on_timing_bar_minigame_completed")):
			timingBar.minigame_completed.connect(Callable(self, "_on_timing_bar_minigame_completed"))
	else:
		printerr("Nó TimingBar não encontrado ou nome incorreto!")

	# Popula o array de corações para fácil gerenciamento da UI
	array_coracoes = [coracao1, coracao2, coracao3, coracao4]
	atualizar_ui_vidas()

	# Conecte os sinais "pressed" dos seus botões de Placa aqui via código
	# ou diretamente pelo editor do Godot. Exemplo via código:
	# var placa_btn_1 = $Placa1 # Ajuste o caminho
	# if placa_btn_1 and not placa_btn_1.is_connected("pressed", Callable(self, "_on_Placa1_pressed")):
	# placa_btn_1.pressed.connect(Callable(self, "_on_Placa1_pressed"))
	# Faça o mesmo para Placa2, Placa3, Placa4

	# Resetar estado inicial do jogo, se necessário
	vidas_atuais = VIDAS_INICIAIS
	placas_instaladas = 0
	placa_solar_ativa_no_minigame = null
	erros_na_tentativa_atual_da_placa = 0
	atualizar_ui_vidas()
	# Poderia também resetar o estado 'is_installed' de todas as placas aqui, se desejar.


## -------------------- FUNÇÕES CONECTADAS AOS SINAIS DOS BOTÕES DAS PLACAS -------------------- ##
# Conecte o sinal "pressed" de cada botão PlacaX a estas funções no editor do Godot
# ou via código no _ready().

func _on_Placa1_pressed() -> void:
	var placa_node: Button = $Placa1 # Ajuste o caminho se Placa1 não for filho direto
	_iniciar_minigame_para_placa(placa_node)

func _on_Placa2_pressed() -> void:
	var placa_node: Button = $Placa2 # Ajuste o caminho
	_iniciar_minigame_para_placa(placa_node)

func _on_Placa3_pressed() -> void:
	var placa_node: Button = $Placa3 # Ajuste o caminho
	_iniciar_minigame_para_placa(placa_node)

func _on_Placa4_pressed() -> void:
	var placa_node: Button = $Placa4 # Ajuste o caminho
	_iniciar_minigame_para_placa(placa_node)


## -------------------- LÓGICA PRINCIPAL DO MINIGAME E ESTADO -------------------- ##
func _iniciar_minigame_para_placa(p_placa_node: Button) -> void:
	if not timingBar:
		printerr("TimingBar não está disponível.")
		return

	if vidas_atuais <= 0:
		print("GAME OVER! Não é possível iniciar nova tentativa.")
		return

	# Verifica se a placa já foi instalada (requer método no script da placa)
	if p_placa_node.has_method("esta_instalado") and p_placa_node.call("esta_instalado"):
		print(p_placa_node.name + " já está instalada.")
		return
	
	# Se o jogador clica numa placa diferente da que estava tentando,
	# ou se não havia nenhuma placa ativa, reseta a contagem de erros da "sequência".
	if placa_solar_ativa_no_minigame != p_placa_node:
		placa_solar_ativa_no_minigame = p_placa_node
		erros_na_tentativa_atual_da_placa = 0
	
	print("Iniciando minigame para: " + placa_solar_ativa_no_minigame.name)
	timingBar.start_minigame() # O script da timingBar deve torná-la visível


func _on_timing_bar_minigame_completed(success: bool) -> void:
	if placa_solar_ativa_no_minigame == null:
		printerr("Minigame completado, mas nenhuma placa solar estava ativa!")
		if timingBar: timingBar.visible = false # Garante que a barra suma
		return

	var painel_processado_nome: String = placa_solar_ativa_no_minigame.name

	if success:
		print("Minigame CONCLUÍDO com SUCESSO para " + painel_processado_nome)
		placas_instaladas += 1
		
		# Chama o método 'instalar' do script da placa ativa
		if placa_solar_ativa_no_minigame.has_method("instalar"):
			placa_solar_ativa_no_minigame.call("instalar") 
		
		erros_na_tentativa_atual_da_placa = 0 # Resetar erros para esta placa, pois acertou
		placa_solar_ativa_no_minigame = null # Nenhuma placa está mais "ativa" para esta sequência

		if placas_instaladas >= MAX_PLACAS_PARA_INSTALAR:
			print("PARABÉNS! Todas as " + str(MAX_PLACAS_PARA_INSTALAR) + " placas instaladas!")
			# Adicionar lógica de vitória aqui (ex: mudar de cena, mostrar UI de vitória)
			# get_tree().change_scene_to_file("res://sua_cena_de_vitoria.tscn")
		else:
			print(painel_processado_nome + " instalada! Faltam " + str(MAX_PLACAS_PARA_INSTALAR - placas_instaladas) + " placas.")
	else:
		print("Minigame FALHOU para " + painel_processado_nome)
		erros_na_tentativa_atual_da_placa += 1
		
		if erros_na_tentativa_atual_da_placa >= MAX_ERROS_POR_TENTATIVA_NA_PLACA:
			print("Errou " + str(MAX_ERROS_POR_TENTATIVA_NA_PLACA) + " vezes na placa " + painel_processado_nome + ". Perdeu uma vida.")
			_perder_vida()
			# Reseta a contagem de erros para esta placa, pois a penalidade (perda de vida) foi aplicada.
			# Se clicar nela de novo, começa uma nova sequência de 2 erros.
			erros_na_tentativa_atual_da_placa = 0
		else:
			print("Erro " + str(erros_na_tentativa_atual_da_placa) + " de " + str(MAX_ERROS_POR_TENTATIVA_NA_PLACA) + " para a placa " + painel_processado_nome)
			# O minigame já se escondeu (ou deveria, pelo script da timingBar).
			# O jogador pode tentar a mesma placa (e o contador de erros continua)
			# ou clicar em outra (o contador de erros vai resetar quando '_iniciar_minigame_para_placa' for chamado para outra placa).
	
	if timingBar: # Garante que a timing bar seja escondida pelo seu próprio script ou aqui
		timingBar.visible = false


## -------------------- GERENCIAMENTO DE VIDAS E UI -------------------- ##
func _perder_vida() -> void:
	if vidas_atuais > 0:
		vidas_atuais -= 1
		print("Vida perdida! Vidas restantes: " + str(vidas_atuais))
		atualizar_ui_vidas()

		if vidas_atuais <= 0:
			_game_over()
	else:
		# Isso não deveria acontecer se a lógica de _game_over() impedir novas ações.
		print("Já está em Game Over, não pode perder mais vidas.")


func atualizar_ui_vidas() -> void:
	for i in range(array_coracoes.size()):
		var coracao_node: TextureRect = array_coracoes[i]
		if coracao_node: # Verifica se o nó do coração existe
			# Se o índice 'i' for menor que o número de vidas atuais, o coração está visível
			coracao_node.visible = (i < vidas_atuais)
		else:
			printerr("Nó de coração não encontrado no array_coracoes no índice: " + str(i))


## -------------------- FIM DE JOGO -------------------- ##
func _game_over() -> void:
	print("GAME OVER!")
	# Adicionar lógica de Game Over aqui:
	# - Mostrar uma tela de "Game Over"
	# - Impedir mais interações com as placas
	# - Oferecer opção de reiniciar ou voltar ao menu principal
	# Exemplo simples:
	# $SuaTelaDeGameOver.visible = true 
	# get_tree().paused = true # Pausa o jogo, mas pode precisar de mais para UI
	# Para reiniciar a cena atual:
	# get_tree().reload_current_scene()
