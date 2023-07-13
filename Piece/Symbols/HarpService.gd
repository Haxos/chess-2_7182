extends Resource
class_name HarpService


static func get_valid_movements(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	array.append_array(BoardService.get_vertical_line(board_data, position))
	array.append_array(BoardService.get_horizontal_line(board_data, position))
	array.append_array(BoardService.get_diagonals_line(board_data, position))
	return array
