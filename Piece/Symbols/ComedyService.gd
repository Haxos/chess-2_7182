extends Resource
class_name ComedyService

static func get_valid_movements(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []

	array.append_array(PieceService.get_diagonals_line(piece_data, board_data))
	
	return array.filter(func(position): return BoardService.is_position_inside_board(board_data, position))
