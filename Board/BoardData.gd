extends Resource
class_name BoardData

@export var pieces_data: Array[PieceData] = []
@export var current_player_coloration: PlayerData.Coloration = PlayerData.Coloration.Black
@export var number_of_moves: int = 0
var min_corner: Vector2i = Vector2i(0, 0)
var max_corner: Vector2i = Vector2i(7, 7)
