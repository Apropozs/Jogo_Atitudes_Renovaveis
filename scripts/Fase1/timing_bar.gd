extends Node2D

func _on_Confirmar_pressed():
	var overlapping = $Pointer.get_overlapping_areas()
	if $Marker in overlapping:
		print("Acertou!")
	else:
		print("Errou!")
