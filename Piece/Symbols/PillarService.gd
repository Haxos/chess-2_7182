extends Resource
class_name PillarService

static func get_valid_movements(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []

	if piece_data.grid_position.x == board_data.min_corner.x or piece_data.grid_position.x == board_data.max_corner.x:
		array.append_array(PieceService.get_vertical_line(piece_data, board_data))
	
	if piece_data.grid_position.y == board_data.min_corner.y or piece_data.grid_position.y == board_data.max_corner.y:
		array.append_array(PieceService.get_horizontal_line(piece_data, board_data))
	
	return array.filter(func(position): return BoardService.is_position_inside_board(board_data, position))
