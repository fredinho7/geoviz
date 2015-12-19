import string
import viz

map_image_file = 'map.png'
contour_file   = 'ar1.txt'

main_node = None

def read_contour(filename):
	coordlist = []
	file = open(filename, "r")
	all_lines = file.readlines()
	file.close()

	for line in all_lines:
		line = line.replace(',','')
		tokens = line.split(" ")
		x = tokens[0]
		y = tokens[1]
		coordlist.append([string.atof(x),string.atof(y)])
	return coordlist

def load_and_create_map(filename):
	# load texture image
	texture = viz.add(filename)
	
	# create on-the-fly geometry
	viz.startLayer(viz.POLYGON)
	viz.texCoord(0,0)
	viz.vertex(-1,0,-1)
	
	viz.texCoord(1,0)
	viz.vertex( 1,0,-1)
	
	viz.texCoord(1,1)
	viz.vertex( 1,0, 1)
	
	viz.texCoord(0,1)
	viz.vertex(-1,0, 1)
	
	map_geometry = viz.endLayer()
	map_geometry.texture(texture)
	return map_geometry
	
def create_contour_geometry(contour): # assumes a list of [x,z] coordinate pairs
	viz.startLayer(viz.LINE_STRIP)
	for v in contour:
		viz.vertex(v[0],0,v[1])
	return viz.endLayer()

def onKeyDown(key):
	global main_node
	if key == viz.KEY_LEFT:
		y,p,r = main_node.getEuler()
		y -= 2
		main_node.setEuler([y,p,r])
	if key == viz.KEY_RIGHT:
		y,p,r = main_node.getEuler()
		y += 2
		main_node.setEuler([y,p,r])
	
	if key == viz.KEY_PAGE_UP:
		sx,sy,sz = main_node.getScale()
		main_node.setScale(sx*1.1, sy*1.1, sz*1.1 )
	
	if key == viz.KEY_PAGE_DOWN:
		sx,sy,sz = main_node.getScale()
		main_node.setScale(sx/1.1, sy/1.1, sz/1.1 )
	
	if key == 'l': # load contour file
		contour = read_contour(contour_file)
		print contour
		contour_geometry = create_contour_geometry(contour)
		contour_geometry.setParent(main_node)
		contour_geometry.setPosition(-0.8,0.05,-1.0)
		contour_geometry.setScale(0.2,0.2,0.2)
		
	return

# create a container node
main_node = viz.addGroup()

# load & create texture geometry
my_map = load_and_create_map(map_image_file)
my_map.setParent(main_node)

# position camera so as to see central part of the scene
viz.MainView.setPosition(0,3,-3)
viz.MainView.lookAt([0,0,0])

#start simulation
viz.go()

# disable free-flying camera controlled by mouse
viz.mouse(viz.OFF)
# now the camera is fixed at position [0,3,-3] looking at the origibn [0,0,0]

# interaction/inspection of map is utilized by other means i.e. rotation/manipulation of the map object
# for instance through keyboard interaction 
viz.callback(viz.KEYDOWN_EVENT,onKeyDown)

