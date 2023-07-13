extends Resource
class_name GlobusCrucigerService


static func get_valid_movements(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	array.append_array(
		[
			Vector2i(position.x + 1, position.y),
			Vector2i(position.x + 1, position.y + 1),
			Vector2i(position.x + 1, position.y - 1),
			Vector2i(position.x - 1, position.y),
			Vector2i(position.x - 1, position.y + 1),
			Vector2i(position.x - 1, position.y - 1),
			Vector2i(position.x, position.y + 1),
			Vector2i(position.x, position.y - 1)
		]
	)
	return array.filter(
		func(position): return BoardService.is_position_inside_board(board_data, position)
	)
