extends Resource
class_name ExponentialCoinService

static func get_valid_movements(piece_data: PieceData, board_data: BoardData, going_up: bool) -> Array[Vector2i]:
	var y = 2 if going_up else -2
	var array: Array[Vector2i] = []
	array.append_array([
		Vector2i(piece_data.grid_position.x + 1, piece_data.grid_position.y + y),
		Vector2i(piece_data.grid_position.x - 1, piece_data.grid_position.y + y),
	])
	
	return array.filter(func(position): return BoardService.is_position_inside_board(board_data, position))
