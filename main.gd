extends Node2D

var world_max_size = Vector2(10, 10)
var world_min_size = Vector2.ZERO

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

func test_live_cells(y, x):
	var adjacency_count = 0
	var place
	
	# □□□
	# □0□
	# □■□ @BUG
	if y+1 < world_max_size.y:
		if world[y+1][x] == 1:
			adjacency_count += 1

	# □■□
	# □0□
	# □□□
	if y-1 > world_min_size.y:
		if world[y-1][x] == 1:
			adjacency_count += 1
			
	# □□□
	# □0■
	# □□□ @BUG
	if x+1 < world_max_size.x:
		if world[y][x+1] == 1:
			adjacency_count += 1
			
	# □□□
	# ■0□
	# □□□
	if x-1 > world_min_size.x:
		if world[y][x-1] == 1:
			adjacency_count += 1
			
	# □□□
	# □0□
	# □□■ @BUG
	if y+1 < world_max_size.y and x+1 < world_max_size.x:
		if world[y+1][x+1] == 1:
			adjacency_count += 1
			
	# □□□
	# □0□
	# ■□□ @BUG
	if y+1 < world_max_size.y and x+1 > world_min_size.x:
		if world[y+1][x-1] == 1:
			print(y,x)
			adjacency_count += 1
			
	# □□■
	# □0□
	# □□□
	if y-1 > world_min_size.y and x+1 < world_max_size.x:
		if world[y-1][x+1] == 1:
			adjacency_count += 1
			
	# ■□□
	# □0□
	# □□□
	if y-1 > world_min_size.y and x-1 > world_min_size.x:
		if world[y-1][x-1] == 1:
			adjacency_count += 1

	return adjacency_count
	
func generate():
	var temp_world = world
	for y in world.size():
		for x in world[y].size():
			var adjacent = test_live_cells(y, x)
			
			if adjacent:
				print(y,x,' ', adjacent)
				
			if world[y][x] == 1:
				if adjacent < 2:
					temp_world[y][x] = 0
				elif adjacent > 3:
					temp_world[y][x] = 0
				elif adjacent == 2 or adjacent == 3:
					temp_world[y][x] = 1
				
			elif world[y][x] == 0:
				if adjacent == 3:
					temp_world[y][x] = 1
					
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
