extends Area3D
class_name Interaction

signal interact_signal
func interact(body: PlayerBody):
	interact_signal.emit()
