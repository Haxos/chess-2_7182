extends Object
class_name BoardService

static func create_board_data() -> BoardData:
	var board_data = BoardData.new()
	board_data.pieces_data = get_default_pieces_data()
	return board_data

static func check_winner(board_data: BoardData) -> PieceData.PlayerColor:
	var opponent: PieceData.PlayerColor = PieceData.PlayerColor.Black if board_data.current_player_color == PieceData.PlayerColor.White else PieceData.PlayerColor.White
	if board_data.pieces_data.any(func(piece_data): return _is_globus_cruciger_dead_for_player(piece_data, opponent)):
		return board_data.current_player_color
	
	if board_data.pieces_data.any(func(piece_data): return _is_globus_cruciger_dead_for_player(piece_data, board_data.current_player_color)):
		return opponent
	
	# check for next turn
	var current_globus_criciger: PieceData = board_data.pieces_data.filter(func(piece_data: PieceData): return piece_data.symbol == PieceData.Symbol.GlobusCruciger and piece_data.player_color == board_data.current_player_color)[0]
	if board_data.pieces_data.filter(func(piece_data: PieceData): return piece_data.player_color == opponent).any(func(piece_data): return PieceService.get_valid_movements(piece_data, board_data).any(func(position): return position == current_globus_criciger.grid_position)):
		return opponent
	
	return PieceData.PlayerColor.None

static func has_piece_in(board_data: BoardData, position: Vector2i) -> bool:
	return board_data.pieces_data.any(func(piece_data: PieceData): return piece_data.grid_position == position and piece_data.is_alive)

static func get_default_pieces_data() -> Array[PieceData]:
	var array: Array[PieceData] = []
	# WHITES
	array.append(PieceService.create_piece_data(PieceData.Symbol.Pillar, PieceData.PlayerColor.White, Vector2i(0,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Comedy, PieceData.PlayerColor.White, Vector2i(1,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Moon, PieceData.PlayerColor.White, Vector2i(2,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Harp, PieceData.PlayerColor.White, Vector2i(3,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.GlobusCruciger, PieceData.PlayerColor.White, Vector2i(4,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Sun, PieceData.PlayerColor.White, Vector2i(5,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Comedy, PieceData.PlayerColor.White, Vector2i(6,0)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Pillar, PieceData.PlayerColor.White, Vector2i(7,0)))
	
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(0,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Candel, PieceData.PlayerColor.White, Vector2i(1,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(2,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(3,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(4,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(5,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Candel, PieceData.PlayerColor.White, Vector2i(6,1)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.White, Vector2i(7,1)))
	
	# BLACKS
	array.append(PieceService.create_piece_data(PieceData.Symbol.Pillar, PieceData.PlayerColor.Black, Vector2i(0,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Comedy, PieceData.PlayerColor.Black, Vector2i(1,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Sun, PieceData.PlayerColor.Black, Vector2i(2,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Harp, PieceData.PlayerColor.Black, Vector2i(3,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.GlobusCruciger, PieceData.PlayerColor.Black, Vector2i(4,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Moon, PieceData.PlayerColor.Black, Vector2i(5,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Comedy, PieceData.PlayerColor.Black, Vector2i(6,7)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Pillar, PieceData.PlayerColor.Black, Vector2i(7,7)))
	
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(0,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Candel, PieceData.PlayerColor.Black, Vector2i(1,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(2,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(3,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(4,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(5,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.Candel, PieceData.PlayerColor.Black, Vector2i(6,6)))
	array.append(PieceService.create_piece_data(PieceData.Symbol.ExponentialCoin, PieceData.PlayerColor.Black, Vector2i(7,6)))
	
	return array

static func get_color_from_position(position: Vector2i) -> PieceData.PlayerColor:
	return PieceData.PlayerColor.Black if position.x % 2 == position.y % 2 else PieceData.PlayerColor.White

static func is_position_inside_board(board_data: BoardData, position: Vector2i) -> bool:
	return not is_position_outside_board(board_data, position)

static func is_position_outside_board(board_data: BoardData, position: Vector2i) -> bool:
	return position.x < board_data.min_corner.x or position.y < board_data.min_corner.y or position.x > board_data.max_corner.x or position.y > board_data.max_corner.y

static func _is_globus_cruciger_dead_for_player(piece_data: PieceData, player_color: PieceData.PlayerColor):
	return piece_data.symbol == PieceData.Symbol.GlobusCruciger and not piece_data.is_alive and piece_data.player_color == player_color
