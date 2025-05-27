extends Button

@onready var texture_rect = $TextureRect

# Substitua os caminhos abaixo pelos corretos do seu projeto
var normal_texture = preload("res://assets/images/MENU/botaoSobre_normal.png")
var hover_texture = preload("res://assets/images/MENU/botaoSobre_hover.png")

func _ready():
	texture_rect.texture = normal_texture
	texture_rect.expand = true
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta):
	if is_hovered():
		texture_rect.texture = hover_texture
	else:
		texture_rect.texture = normal_texture
