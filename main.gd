extends Node2D

var world_max_size = Vector2(9, 9)
var world_min_size = Vector2(-1, -1)

var world: Array = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

func test_border(y,x,border_y,border_x):
	var y_done = false
	var x_done = false
	if border_y > 0:
		if y+border_y < world_max_size.y:
			y_done = true
	elif border_y < 0:
		if y+border_y > world_min_size.y:
			y_done = true
	else:
		y_done = true
	
	if border_x > 0:
		if x+border_x < world_max_size.x:
			x_done = true
	elif border_x < 0:
		if x+border_x > world_min_size.x:
			
			x_done = true
	else:
		x_done = true
	
	if y_done and x_done:
		return true
	return false

func test_cell(y,x,side_y,side_x):
	var tested_cell_y = y+side_y
	var tested_cell_x = x+side_x
	
	if world[tested_cell_y][tested_cell_x] == 1:
		return true
	return false

func test_live_cells(y, x):
	var adjacency_count = 0
	
	# □□□
	# □0□
	# □■□ 
	if test_border(y, x, 1, 0):
		if test_cell(y, x, 1, 0):
			adjacency_count += 1

	# □■□
	# □0□
	# □□□
	if test_border(y, x, -1, 0):
		if test_cell(y, x, -1, 0):
			adjacency_count += 1
			
	# □□□
	# □0■
	# □□□ 
	if test_border(y, x, 0, 1):
		if test_cell(y, x, 0, 1):
			adjacency_count += 1
			
	# □□□
	# ■0□
	# □□□
	if test_border(y, x, 0, -1):
		if test_cell(y, x, 0, -1):
			adjacency_count += 1
			
	# □□□
	# □0□
	# □□■ 
	if test_border(y, x, 1, 1):
		if test_cell(y, x, 1, 1):
			adjacency_count += 1
			
	# □□□
	# □0□
	# ■□□ 
	if test_border(y, x, 1, -1):
		if test_cell(y, x, 1, -1):
			adjacency_count += 1
			
	# □□■
	# □0□
	# □□□
	if test_border(y, x, -1, 1):
		if test_cell(y, x, -1, 1):
			adjacency_count += 1
			
	# ■□□
	# □0□
	# □□□
	if test_border(y, x, -1, -1):
		if test_cell(y, x, -1, -1):
			adjacency_count += 1

	return adjacency_count
	
func generate() -> void :
	var temp_world = world
	for y in world.size():
		for x in world[y].size():
			
			var adjacent = test_live_cells(y, x)

			if world[y][x] == 1:
				if adjacent < 2:
					temp_world[y][x] = 0 # @BUG
					print("<2")
				elif adjacent > 3:
					temp_world[y][x] = 0
					print(">3")
				elif adjacent == 2 or adjacent == 3:
					print("2or3")
			else:
				if adjacent == 3:
					temp_world[y][x] = 1
					print("==3")
				elif adjacent == 1:
					print("test")
					
	world = temp_world
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		generate()
		refresh_tilemap()

func refresh_tilemap():
	for y in world.size():
		for x in world.size():
			if world[y][x]==1:
				$TileMap.set_cell(0, Vector2(x, y), 0, Vector2(20, 13))
			elif world[y][x]==0:
				$TileMap.set_cell(0, Vector2(x, y), 0, Vector2(63, 24))
func _ready():
	refresh_tilemap()
