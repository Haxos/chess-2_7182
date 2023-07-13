extends Resource
class_name PieceData

enum Symbol {
	Comedy = 0,
	Tragedy = 2,
	Pillar = 16,
	Harp = 32,
	Note = 34,
	Sun = 48,
	Moon = 64,
	GlobusCruciger = 80,
	Candel = 96,
	CandelLit = 98,
	ExponentialCoin = 112
}

signal symbol_changed

@export var id: StringName

@export var symbol: Symbol = Symbol.Comedy:
	set(value):
		symbol = value
		emit_changed()
		symbol_changed.emit()

@export var player_coloration: PlayerData.Coloration = PlayerData.Coloration.Black:
	set(value):
		player_coloration = value
		emit_changed()

@export var grid_position: Vector2i = Vector2i.ZERO:  # Top-left corner
	set(value):
		grid_position = value
		emit_changed()

@export var is_alive: bool = true:
	set(value):
		is_alive = value
		emit_changed()
