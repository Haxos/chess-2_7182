extends Object
class_name BoardService


static func apply_movement(
	board_data: BoardData, current_piece_data: PieceData, next_position: Vector2i
) -> void:
	var maybe_interactable_piece = board_data.pieces_data.filter(
		func(piece_data: PieceData): return (
			piece_data.grid_position == next_position and piece_data.is_alive
		)
	)
	if not maybe_interactable_piece.is_empty():
		var interactable_piece: PieceData = maybe_interactable_piece[0]
		if (
			current_piece_data.symbol == PieceData.Symbol.Candel
			and interactable_piece.symbol == PieceData.Symbol.Sun
		):
			current_piece_data.symbol = PieceData.Symbol.CandelLit
			current_piece_data.grid_position = next_position
		elif (
			interactable_piece.symbol == PieceData.Symbol.Candel
			and current_piece_data.symbol == PieceData.Symbol.Sun
		):
			interactable_piece.symbol = PieceData.Symbol.CandelLit
		elif current_piece_data.symbol == PieceData.Symbol.Harp:
			interactable_piece.is_alive = false
			current_piece_data.symbol = PieceData.Symbol.Note
			current_piece_data.grid_position = next_position
		elif interactable_piece.symbol == PieceData.Symbol.Harp:
			current_piece_data.is_alive = false
			interactable_piece.symbol = PieceData.Symbol.Note
		else:
			interactable_piece.is_alive = false
			current_piece_data.grid_position = next_position
	else:
		current_piece_data.grid_position = next_position


static func apply_self_interaction(board_data: BoardData, piece_data: PieceData) -> void:
	if (
		piece_data.symbol == PieceData.Symbol.Comedy
		and board_data.current_player_coloration == PlayerData.Coloration.White
	):
		piece_data.symbol = PieceData.Symbol.Tragedy
	if (
		piece_data.symbol == PieceData.Symbol.Tragedy
		and board_data.current_player_coloration == PlayerData.Coloration.Black
	):
		piece_data.symbol = PieceData.Symbol.Comedy
	if (
		piece_data.symbol == PieceData.Symbol.Moon
		and (
			BoardService.get_color_from_position(piece_data.grid_position)
			== PlayerData.Coloration.White
		)
	):
		piece_data.symbol = PieceData.Symbol.Sun
	if (
		piece_data.symbol == PieceData.Symbol.Sun
		and (
			BoardService.get_color_from_position(piece_data.grid_position)
			== PlayerData.Coloration.Black
		)
	):
		piece_data.symbol = PieceData.Symbol.Moon


static func create_board_data() -> BoardData:
	var board_data = BoardData.new()
	board_data.pieces_data = get_default_pieces_data()
	return board_data


static func check_winner(board_data: BoardData) -> PlayerData.Coloration:
	var opponent: PlayerData.Coloration = (
		PlayerData.Coloration.Black
		if board_data.current_player_coloration == PlayerData.Coloration.White
		else PlayerData.Coloration.White
	)
	if board_data.pieces_data.any(
		func(piece_data): return _is_globus_cruciger_dead_for_player(piece_data, opponent)
	):
		return board_data.current_player_coloration

	if board_data.pieces_data.any(
		func(piece_data): return _is_globus_cruciger_dead_for_player(
			piece_data, board_data.current_player_coloration
		)
	):
		return opponent

	# check for next turn
	var current_globus_criciger: PieceData = (
		board_data
		. pieces_data
		. filter(
			func(piece_data: PieceData): return (
				piece_data.symbol == PieceData.Symbol.GlobusCruciger
				and piece_data.player_coloration == board_data.current_player_coloration
			)
		)[0]
	)
	if (
		board_data
		. pieces_data
		. filter(func(piece_data: PieceData): return piece_data.player_coloration == opponent)
		. any(
			func(piece_data): return BoardService.get_valid_movements(board_data, piece_data).any(
				func(position): return position == current_globus_criciger.grid_position
			)
		)
	):
		return opponent

	return PlayerData.Coloration.None


static func has_piece_in(board_data: BoardData, position: Vector2i) -> bool:
	return board_data.pieces_data.any(
		func(piece_data: PieceData): return (
			piece_data.grid_position == position and piece_data.is_alive
		)
	)


static func get_default_pieces_data() -> Array[PieceData]:
	var array: Array[PieceData] = []

	# WHITES
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Pillar, PlayerData.Coloration.White, Vector2i(0, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Comedy, PlayerData.Coloration.White, Vector2i(1, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Moon, PlayerData.Coloration.White, Vector2i(2, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Harp, PlayerData.Coloration.White, Vector2i(3, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.GlobusCruciger, PlayerData.Coloration.White, Vector2i(4, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Sun, PlayerData.Coloration.White, Vector2i(5, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Comedy, PlayerData.Coloration.White, Vector2i(6, 0)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Pillar, PlayerData.Coloration.White, Vector2i(7, 0)
		)
	)

	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(0, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Candel, PlayerData.Coloration.White, Vector2i(1, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(2, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(3, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(4, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(5, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Candel, PlayerData.Coloration.White, Vector2i(6, 1)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.White, Vector2i(7, 1)
		)
	)

	# BLACKS
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Pillar, PlayerData.Coloration.Black, Vector2i(0, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Comedy, PlayerData.Coloration.Black, Vector2i(1, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Sun, PlayerData.Coloration.Black, Vector2i(2, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Harp, PlayerData.Coloration.Black, Vector2i(3, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.GlobusCruciger, PlayerData.Coloration.Black, Vector2i(4, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Moon, PlayerData.Coloration.Black, Vector2i(5, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Comedy, PlayerData.Coloration.Black, Vector2i(6, 7)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Pillar, PlayerData.Coloration.Black, Vector2i(7, 7)
		)
	)

	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(0, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Candel, PlayerData.Coloration.Black, Vector2i(1, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(2, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(3, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(4, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(5, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.Candel, PlayerData.Coloration.Black, Vector2i(6, 6)
		)
	)
	array.append(
		PieceService.create_piece_data(
			PieceData.Symbol.ExponentialCoin, PlayerData.Coloration.Black, Vector2i(7, 6)
		)
	)

	return array


static func get_color_from_position(position: Vector2i) -> PlayerData.Coloration:
	return (
		PlayerData.Coloration.Black
		if position.x % 2 == position.y % 2
		else PlayerData.Coloration.White
	)


static func get_diagonals_line(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	array.append_array(
		_get_diagonal(
			board_data,
			position,
			Vector2i(position.x - 1, position.y - 1),
			Vector2i(board_data.min_corner.x - 1, board_data.min_corner.y - 1),
			Vector2i(-1, -1)
		)
	)
	array.append_array(
		_get_diagonal(
			board_data,
			position,
			Vector2i(position.x - 1, position.y + 1),
			Vector2i(board_data.min_corner.x - 1, board_data.max_corner.y + 1),
			Vector2i(-1, 1)
		)
	)
	array.append_array(
		_get_diagonal(
			board_data,
			position,
			Vector2i(position.x + 1, position.y - 1),
			Vector2i(board_data.max_corner.x + 1, board_data.min_corner.y - 1),
			Vector2i(1, -1)
		)
	)
	array.append_array(
		_get_diagonal(
			board_data,
			position,
			Vector2i(position.x + 1, position.y + 1),
			Vector2i(board_data.max_corner.x + 1, board_data.max_corner.y + 1),
			Vector2i(1, 1)
		)
	)
	return array


static func get_horizontal_line(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []

	for x in range(position.x - 1, board_data.min_corner.x - 1, -1):
		var new_position = Vector2i(x, position.y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break

	for x in range(position.x + 1, board_data.max_corner.x + 1):
		var new_position = Vector2i(x, position.y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break

	return array


static func get_vertical_line(board_data: BoardData, position: Vector2i) -> Array[Vector2i]:
	var array: Array[Vector2i] = []

	for y in range(position.y - 1, board_data.min_corner.y - 1, -1):
		var new_position = Vector2i(position.x, y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break

	for y in range(position.y + 1, board_data.max_corner.y + 1):
		var new_position = Vector2i(position.x, y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break

	return array


static func get_valid_movements(board_data: BoardData, piece_data: PieceData) -> Array[Vector2i]:
	match piece_data.symbol:
		PieceData.Symbol.Candel:
			return CandelService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.CandelLit:
			return CandelLitService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Comedy:
			return ComedyService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.ExponentialCoin:
			var going_up = piece_data.player_coloration == PlayerData.Coloration.White
			return ExponentialCoinService.get_valid_movements(
				board_data, piece_data.grid_position, going_up
			)
		PieceData.Symbol.GlobusCruciger:
			return GlobusCrucigerService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Harp:
			return HarpService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Moon:
			return MoonService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Note:
			return NoteService.get_valid_movements()
		PieceData.Symbol.Pillar:
			return PillarService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Sun:
			return SunService.get_valid_movements(board_data, piece_data.grid_position)
		PieceData.Symbol.Tragedy:
			return TragedyService.get_valid_movements(board_data, piece_data.grid_position)
		_:
			return []


static func is_position_inside_board(board_data: BoardData, position: Vector2i) -> bool:
	return not is_position_outside_board(board_data, position)


static func is_position_outside_board(board_data: BoardData, position: Vector2i) -> bool:
	return (
		position.x < board_data.min_corner.x
		or position.y < board_data.min_corner.y
		or position.x > board_data.max_corner.x
		or position.y > board_data.max_corner.y
	)


static func _get_diagonal(
	board_data: BoardData, position: Vector2i, begin: Vector2i, end: Vector2i, steps: Vector2i
) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	var i = 0
	for x in range(begin.x - 1, end.x - 1, steps.x):
		for y in range(begin.y - 1, end.y - 1, steps.y):
			i += 1
			var new_position = Vector2i(position.x + (i * steps.x), position.y + (i * steps.y))
			array.append(new_position)
			if BoardService.has_piece_in(board_data, new_position):
				return array
	return array


static func _is_globus_cruciger_dead_for_player(
	piece_data: PieceData, player_coloration: PlayerData.Coloration
):
	return (
		piece_data.symbol == PieceData.Symbol.GlobusCruciger
		and not piece_data.is_alive
		and piece_data.player_coloration == player_coloration
	)
