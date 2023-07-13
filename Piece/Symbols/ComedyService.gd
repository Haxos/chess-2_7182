extends Resource
class_name ComedyService


static func get_valid_movements(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	array.append_array(BoardService.get_diagonals_line(board_data, position))
	return array.filter(
		func(position): return BoardService.is_position_inside_board(board_data, position)
	)
