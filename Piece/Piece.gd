@tool
extends Node2D
class_name Piece

signal on_over
signal on_exit
signal on_click
signal on_symbol_change

@export var piece_data: PieceData:
	set(value):
		piece_data = value

		if piece_data != null:
			if not piece_data.is_connected("changed", _update):
				piece_data.connect("changed", _update)
				_update()
			if not piece_data.is_connected("symbol_changed", _symbol_changed):
				piece_data.connect("symbol_changed", _symbol_changed)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _update():
	$Token.frame = piece_data.player_coloration
	$Symbol.frame = piece_data.symbol + piece_data.player_coloration
	self.visible = piece_data.is_alive


func _symbol_changed():
	on_symbol_change.emit(piece_data.symbol)


func _on_area_2d_input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_click.emit(piece_data)


func _on_area_2d_mouse_entered():
	on_over.emit(piece_data)


func _on_area_2d_mouse_exited():
	on_exit.emit(piece_data)
