extends Resource
class_name PieceData

enum Symbol {
	Comedy          = 0,
	Tragedy         = 2,
	Pillar           = 16,
	Harp            = 32,
	Note            = 34,
	Sun             = 48,
	Moon            = 64,
	GlobusCruciger  = 80,
	Candel          = 96,
	CandelLit       = 98,
	ExponentialCoin = 112
}

enum PlayerColor {
	Black = 0,
	White = 1,
	None  = 2,
}

@export var id: StringName

@export var symbol: Symbol = Symbol.Comedy:
	set(value):
		symbol = value
		emit_changed()

@export var player_color: PlayerColor = PlayerColor.Black:
	set(value):
		player_color = value
		emit_changed()
		
@export var grid_position: Vector2i = Vector2i.ZERO: # Top-left corner
	set(value):
		grid_position = value
		emit_changed()

@export var is_alive: bool = true:
	set(value):
		is_alive = value
		emit_changed()
