import viz

map_image_file = 'refimage.png'

main_node = None

def load_and_create_map(filename):
	# load texture image
	texture = viz.add(filename)
	
	# create on-the-fly geometry
	viz.startLayer(viz.POLYGON)
	viz.texCoord(0,0)
	viz.vertex(-10,0,-10)
	
	viz.texCoord(1,0)
	viz.vertex( 10,0,-10)
	
	viz.texCoord(1,1)
	viz.vertex( 10,0, 10)
	
	viz.texCoord(0,1)
	viz.vertex(-10,0, 10)
	
	map_geometry = viz.endLayer()
	map_geometry.texture(texture)
	return map_geometry

def onKeyDown(key):
	global main_node
	if key == viz.KEY_LEFT:
		y,p,r = main_node.getEuler()
		y -= 4
		main_node.setEuler([y,p,r])
	if key == viz.KEY_RIGHT:
		y,p,r = main_node.getEuler()
		y += 4
		main_node.setEuler([y,p,r])
	
	if key == viz.KEY_UP:
		sx,sy,sz = main_node.getScale()
		sy += 4
		main_node.setScale(sx*1.1, sy*1.1, sz*1.1 )
	
	if key == viz.KEY_DOWN:
		sx,sy,sz = main_node.getScale()
		sy -= 4
		main_node.setScale(sx/1.1, sy/1.1, sz/1.1 )
		

	return

# create a container node
main_node = viz.addGroup()

# load & create texture geometry
my_map = load_and_create_map(map_image_file)
my_map.setParent(main_node)

# position camera so as to see central part of the scene
viz.MainView.setPosition(0,30,-3)
viz.MainView.lookAt([0,0,0])

#start simulation
viz.go()

# disable free-flying camera controlled by mouse
viz.mouse(viz.OFF)
# now the camera is fixed at position [0,3,-3] looking at the origibn [0,0,0]

# interaction/inspection of map is utilized by other means i.e. rotation/manipulation of the map object
# for instance through keyboard interaction 
viz.callback(viz.KEYDOWN_EVENT,onKeyDown)


