extends Object
class_name PieceService


static func create_piece_data(
	symbol: PieceData.Symbol, player_coloration: PlayerData.Coloration, position: Vector2i
) -> PieceData:
	var format_id = "0x{symbol}_{color}_{position}"
	var piece_data = PieceData.new()
	piece_data.id = format_id.format(
		{"symbol": symbol, "color": player_coloration, "position": position}
	)
	piece_data.symbol = symbol
	piece_data.player_coloration = player_coloration
	piece_data.grid_position = position
	return piece_data
