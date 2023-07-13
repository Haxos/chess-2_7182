extends Resource
class_name CandelLitService

static func get_valid_movements(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	array.append_array(PieceService.get_vertical_line(piece_data, board_data))
	array.append_array(PieceService.get_horizontal_line(piece_data, board_data))
	array.append_array(PieceService.get_diagonals_line(piece_data, board_data))
	
	return array
