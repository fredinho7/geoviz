import viz
import vizshape

#Get reference image from Erdas analysis
map_image_file = 'refimage.png'

def load_and_create_map(filename):
	# load texture image
	texture = viz.add(filename)
	
	# create on-the-fly
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

# load & create texture geometry
load_and_create_map(map_image_file)

# position camera so as to see central part of the scene
viz.MainView.setPosition(0,30,-3)
viz.MainView.lookAt([0,0,0])

vizshape.addAxes()

#start simulation
viz.go()

