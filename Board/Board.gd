@tool
extends Node2D

const GRID_SIZE = 32
const TOP_LEFT_CORNER_OFFSET: Vector2i = Vector2i(-112, -112)
const TOP_LEFT_TILE_MAP_COORDONATES: Vector2i = Vector2i(8, 8)
const SOURCE_ID = 1
const MOVEMENT_ATLAS_COORDONATES = Vector2i(5, 1)
const MOVEMENT_LAYER_ID = 2
const KILLABLE_ATLAS_COORDONATES = Vector2i(5, 2)
const KILLABLE_LAYER_ID = 3

signal next_turn
signal victory
signal defeat

@export var board_data: BoardData
@export var piece_scene: PackedScene
var _is_initialisation_finished = false
var number_of_moves = 0
var _previous_piece_data_entered: PieceData = null
var _piece_data_clicked: PieceData = null
var _game_ended = false

func new_board():
	board_data = BoardService.create_board_data()
	board_data.number_of_moves = 0
	board_data.current_player_color = PieceData.PlayerColor.Black
	_instanciate_pieces()
	_is_initialisation_finished = true
	_game_ended = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _is_initialisation_finished:
		_positionate_pieces()

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		_move_piece()

func _instanciate_pieces():
	get_tree().call_group("pieces", "queue_free")
	for piece_data in board_data.pieces_data:
		var piece = piece_scene.instantiate()
		piece.piece_data = piece_data
		piece.name = piece_data.id
		$Pieces.add_child(piece)
		piece.connect("on_over", _on_piece_over)
		piece.connect("on_exit", _on_piece_exit)
		piece.connect("on_click", _on_piece_click)

func _positionate_pieces():
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.position = (piece.piece_data.grid_position * GRID_SIZE) + TOP_LEFT_CORNER_OFFSET

func _move_piece():
	if _game_ended or _piece_data_clicked == null:
		return
	
	var mouse: Vector2 = get_global_mouse_position()
	var click_position: Vector2i = $TileMap.local_to_map($TileMap.to_local(mouse))
	var movement_position: Vector2i = click_position - TOP_LEFT_TILE_MAP_COORDONATES
	var valid_movements = PieceService.get_valid_movements(_piece_data_clicked, board_data)
	
	if valid_movements.any(func(valid_movement): return valid_movement == movement_position):
		_apply_pieces_behaviour_changes(movement_position)
		_check_victory_conditions()
		if _game_ended:
			return

		_next_player()
		_apply_pieces_behaviour_changes_self_interaction()
	
	_piece_data_clicked = null
	_clean_layers()

func _check_victory_conditions():
	var winner = BoardService.check_winner(board_data)
	if winner == board_data.current_player_color:
		victory.emit()
	
	var opponent: PieceData.PlayerColor = PieceData.PlayerColor.Black if board_data.current_player_color == PieceData.PlayerColor.White else PieceData.PlayerColor.White
	if winner == opponent:
		defeat.emit()

func _apply_pieces_behaviour_changes(movement_position: Vector2i):
	var maybe_interactable_piece = board_data.pieces_data.filter(func(piece_data: PieceData): return piece_data.grid_position == movement_position and piece_data.is_alive)
	if not maybe_interactable_piece.is_empty():
		var interactable_piece: PieceData = maybe_interactable_piece[0]
		if _piece_data_clicked.symbol == PieceData.Symbol.Candel and interactable_piece.symbol == PieceData.Symbol.Sun:
			_piece_data_clicked.symbol = PieceData.Symbol.CandelLit
			_piece_data_clicked.grid_position = movement_position
			$CandleLit.play()
		elif interactable_piece.symbol == PieceData.Symbol.Candel and _piece_data_clicked.symbol == PieceData.Symbol.Sun:
			interactable_piece.symbol = PieceData.Symbol.CandelLit
			$CandleLit.play()
		elif _piece_data_clicked.symbol == PieceData.Symbol.Harp:
			interactable_piece.is_alive = false
			_piece_data_clicked.symbol = PieceData.Symbol.Note
			_piece_data_clicked.grid_position = movement_position
			$Harp.play()
		elif interactable_piece.symbol == PieceData.Symbol.Harp:
			_piece_data_clicked.is_alive = false
			interactable_piece.symbol = PieceData.Symbol.Note
			$Harp.play()
		else:
			interactable_piece.is_alive = false
			_piece_data_clicked.grid_position = movement_position
	else:
		_piece_data_clicked.grid_position = movement_position
	_apply_pieces_behaviour_changes_self_interaction()

func _apply_pieces_behaviour_changes_self_interaction():
	for piece_data in board_data.pieces_data:
		if piece_data.symbol == PieceData.Symbol.Comedy and board_data.current_player_color == PieceData.PlayerColor.White:
			piece_data.symbol = PieceData.Symbol.Tragedy
		if piece_data.symbol == PieceData.Symbol.Tragedy and board_data.current_player_color == PieceData.PlayerColor.Black:
			piece_data.symbol = PieceData.Symbol.Comedy
		if piece_data.symbol == PieceData.Symbol.Moon and BoardService.get_color_from_position(piece_data.grid_position) == PieceData.PlayerColor.White:
			piece_data.symbol = PieceData.Symbol.Sun
		if piece_data.symbol == PieceData.Symbol.Sun and BoardService.get_color_from_position(piece_data.grid_position) == PieceData.PlayerColor.Black:
			piece_data.symbol = PieceData.Symbol.Moon

func _next_player():
	board_data.current_player_color = PieceData.PlayerColor.Black if board_data.current_player_color == PieceData.PlayerColor.White else PieceData.PlayerColor.White
	board_data.number_of_moves += 1
	next_turn.emit()

func _display_layers(piece_data: PieceData):
	var movements = PieceService.get_valid_movements(piece_data, board_data)
	for movement in movements:
		if BoardService.has_piece_in(board_data, movement):
			$TileMap.set_cell(KILLABLE_LAYER_ID, movement + TOP_LEFT_TILE_MAP_COORDONATES, SOURCE_ID, KILLABLE_ATLAS_COORDONATES)
		else:
			$TileMap.set_cell(MOVEMENT_LAYER_ID, movement + TOP_LEFT_TILE_MAP_COORDONATES, SOURCE_ID, MOVEMENT_ATLAS_COORDONATES)

func _clean_layers():
	$TileMap.clear_layer(MOVEMENT_LAYER_ID)
	$TileMap.clear_layer(KILLABLE_LAYER_ID)
	
func _on_piece_click(piece_data: PieceData):
	if _game_ended or piece_data.player_color != board_data.current_player_color:
		return
	
	_piece_data_clicked = piece_data
	_clean_layers()
	_display_layers(piece_data)

func _on_piece_over(piece_data: PieceData):
	if _game_ended or _piece_data_clicked != null or piece_data.player_color != board_data.current_player_color:
		return

	_previous_piece_data_entered = piece_data
	_clean_layers()
	_display_layers(piece_data)

func _on_piece_exit(piece_data: PieceData):
	if _game_ended or _piece_data_clicked == null and _previous_piece_data_entered == piece_data:
		_clean_layers()
