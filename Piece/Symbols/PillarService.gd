extends Resource
class_name PillarService


static func get_valid_movements(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []

	if position.x == board_data.min_corner.x or position.x == board_data.max_corner.x:
		array.append_array(BoardService.get_vertical_line(board_data, position))

	if position.y == board_data.min_corner.y or position.y == board_data.max_corner.y:
		array.append_array(BoardService.get_horizontal_line(board_data, position))

	return array.filter(
		func(position): return BoardService.is_position_inside_board(board_data, position)
	)
