@tool
extends Node2D
class_name Piece

signal on_over
signal on_exit
signal on_click

@export var piece_data: PieceData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if piece_data != null:
		$Token.frame = piece_data.player_color
		$Symbol.frame = piece_data.symbol + piece_data.player_color
		self.visible = piece_data.is_alive

func _on_area_2d_input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_click.emit(piece_data)

func _on_area_2d_mouse_entered():
	on_over.emit(piece_data)

func _on_area_2d_mouse_exited():
	on_exit.emit(piece_data)
