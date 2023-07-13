extends Resource
class_name CandelService

static func get_valid_movements(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	array.append_array([
		Vector2i(piece_data.grid_position.x + 1, piece_data.grid_position.y),
		Vector2i(piece_data.grid_position.x - 1, piece_data.grid_position.y),
		Vector2i(piece_data.grid_position.x, piece_data.grid_position.y + 1),
		Vector2i(piece_data.grid_position.x, piece_data.grid_position.y - 1),
	])
	
	return array.filter(func(position): return BoardService.is_position_inside_board(board_data, position))
