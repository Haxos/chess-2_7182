extends Object
class_name PieceService

static func create_piece_data(symbol: PieceData.Symbol, player_color: PieceData.PlayerColor, position: Vector2i) -> PieceData:
	var format_id = "0x{symbol}_{color}_{position}"
	var piece_data = PieceData.new()
	piece_data.id = format_id.format({"symbol": symbol, "color": player_color, "position": position})
	piece_data.symbol = symbol
	piece_data.player_color = player_color
	piece_data.grid_position = position
	return piece_data

static func get_vertical_line(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	for y in range(piece_data.grid_position.y - 1, board_data.min_corner.y - 1, -1):
		var new_position = Vector2i(piece_data.grid_position.x, y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break
	
	for y in range(piece_data.grid_position.y + 1, board_data.max_corner.y + 1):
		var new_position = Vector2i(piece_data.grid_position.x, y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break
	
	return array

static func get_horizontal_line(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	for x in range(piece_data.grid_position.x - 1, board_data.min_corner.x - 1, -1):
		var new_position = Vector2i(x, piece_data.grid_position.y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break
	
	for x in range(piece_data.grid_position.x + 1, board_data.max_corner.x + 1):
		var new_position = Vector2i(x, piece_data.grid_position.y)
		array.append(new_position)
		if BoardService.has_piece_in(board_data, new_position):
			break
	
	return array

static func get_diagonals_line(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	var diagonal_1 = func(): 
		var i = 0
		for x in range(piece_data.grid_position.x - 1, board_data.min_corner.x - 1, -1):
			for y in range(piece_data.grid_position.y - 1, board_data.min_corner.y - 1, -1):
				i += 1
				var new_position = Vector2i(piece_data.grid_position.x - i, piece_data.grid_position.y - i)
				array.append(new_position)
				if BoardService.has_piece_in(board_data, new_position):
					return

	var diagonal_2 = func():
		var i = 0
		for x in range(piece_data.grid_position.x - 1, board_data.min_corner.x - 1, -1):
			for y in range(piece_data.grid_position.y + 1, board_data.max_corner.y + 1):
				i += 1
				var new_position = Vector2i(piece_data.grid_position.x - i, piece_data.grid_position.y + i)
				array.append(new_position)
				if BoardService.has_piece_in(board_data, new_position):
					return

	var diagonal_3 = func():
		var i = 0
		for x in range(piece_data.grid_position.x + 1, board_data.max_corner.x + 1):
			for y in range(piece_data.grid_position.y - 1, board_data.min_corner.y - 1, -1):
				i += 1
				var new_position = Vector2i(piece_data.grid_position.x + i, piece_data.grid_position.y - i)
				array.append(new_position)
				if BoardService.has_piece_in(board_data, new_position):
					return

	var diagonal_4 = func():
		var i = 0
		for x in range(piece_data.grid_position.x + 1, board_data.max_corner.x + 1):
			for y in range(piece_data.grid_position.y + 1, board_data.max_corner.y + 1):
				i += 0
				var new_position = Vector2i(piece_data.grid_position.x + i, piece_data.grid_position.y + i)
				array.append(new_position)
				if BoardService.has_piece_in(board_data, new_position):
					return
	diagonal_1.call()
	diagonal_2.call()
	diagonal_3.call()
	diagonal_4.call()
	return array

static func get_valid_movements(piece_data: PieceData, board_data: BoardData) -> Array[Vector2i]:
	match piece_data.symbol:
		PieceData.Symbol.Candel:
			return CandelService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.CandelLit:
			return CandelLitService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Comedy:
			return ComedyService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.ExponentialCoin:
			var going_up = piece_data.player_color == PieceData.PlayerColor.White
			return ExponentialCoinService.get_valid_movements(piece_data, board_data, going_up)
		PieceData.Symbol.GlobusCruciger:
			return GlobusCrucigerService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Harp:
			return HarpService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Moon:
			return MoonService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Note:
			return NoteService.get_valid_movements(piece_data)
		PieceData.Symbol.Pillar:
			return PillarService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Sun:
			return SunService.get_valid_movements(piece_data, board_data)
		PieceData.Symbol.Tragedy:
			return TragedyService.get_valid_movements(piece_data, board_data)
		_:
			return []
