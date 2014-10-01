window.onload = () ->

	canvas = document.getElementById('myCanvas')
	alert "Canvas not found" if !canvas

	context = canvas.getContext('2d')  # we need the context object to call drawing methods
	alert "Context not found" if !context

	# we create a node list and a link list
	node_list = []
	link_list = []

	# we create a node class and a link class
	class Node
		radius: 10

	class Link
		constructor: (node_start, node_end) ->
			@node_start = node_start
			@node_end   = node_end
		

	linkingFlags = {linking: false}
	
	# jQuery code to get mouse clicks
	$('#myCanvas').mousedown((mouseEvent) ->
		# we get the mouse position
		$div = $(mouseEvent.target)
		offset = $div.offset()
		x = mouseEvent.clientX - offset.left
		y = mouseEvent.clientY - offset.top
		console.debug('x: ' + x + ', y: ' + y)

		switch mouseEvent.which
			when 1  # left mouse button
				linking = false

				# we check if there is already a node at that position
				# if so, we prevent from creating a new one, 
				# we suppose the user is trying to link two nodes
				for node in node_list
					if window.distanceBetweenPoints(node.x, node.y, x, y) < 2*node.radius
						linkingFlags = {linking: true, node_start: node}
						linking = true
						break

				if linking is true    # user is linking two nodes
					break
				else                  # user is creating a new node
					node = new Node
					node.x = x
					node.y = y
					node_list.push(node)
				
	)
	$('#myCanvas').mouseup((mouseEvent) ->
		# we get the mouse position
		$div = $(mouseEvent.target)
		offset = $div.offset()
		x = mouseEvent.clientX - offset.left
		y = mouseEvent.clientY - offset.top
		console.debug('x: ' + x + ', y: ' + y)

		switch mouseEvent.which
			when 1  # left mouse button

				# if user was not trying to link nodes
				# (user pressed button but mouse was not on a node)
				if linkingFlags.linking is false
					break

				# we check if user release mouse button on a node
				for node in node_list
					if window.distanceBetweenPoints(node.x, node.y, x, y) < 2*node.radius

						# we check that it's not the same node as the start node
						if node == linkingFlags.node_start
							break

						# we create a link between the two nodes
						link = new Link(linkingFlags.node_start, node)
						# link.node_start = linkingFlags.node_start
						# link.node_end = node

						link_list.push(link)
						break
				
				linkingFlags.linking = false  # reset flag
	)

	# the drawing function
	animate = () ->
		
		# we draw a rectangle to delimitate the drawing zone
		context.beginPath()
		context.strokeStyle = '#000000'
		context.moveTo(0, 0)
		context.lineTo(canvas.width, 0)
		context.lineTo(canvas.width, canvas.height)
		context.lineTo(0, canvas.height)
		context.lineTo(0, 0)
		context.stroke()
		context.closePath()

		# we draw all lines
		context.beginPath()
		context.lineWidth = 1
		context.strokeStyle = '#000000'

		for link in link_list
			context.moveTo(link.node_start.x, link.node_start.y)
			context.lineTo(link.node_end.x, link.node_end.y)
			drawArrow(link, context)  # to draw the arrow at the end of the link

		context.stroke()
		context.closePath()

		# we draw all circles
		context.beginPath()

		context.strokeStyle = '#ffff00'
		for node in node_list
			context.moveTo(node.x, node.y)
			context.arc(node.x, node.y, node.radius, 0, 2 * Math.PI)

		context.fillStyle = 'yellow'
		context.fill()
		context.stroke()
		context.closePath()

	myInterval = setInterval(animate, 1000/10)  # 10 FPS


	# a function to draw a line with an arrow at the end
	drawArrow = (link, context) ->
		# http://stackoverflow.com/questions/10316180/
		# how-to-calculate-the-coordinates-of-a-arrowhead-based-on-the-arrow

		# we compute the point where the arrow aims:
		# 1) we compute the vector of the entire line
		dx = link.node_end.x - link.node_start.x
		dy = link.node_end.y - link.node_start.y
		# 2) we compute the unit vector associated
		dx_norm = dx / window.distanceBetweenNodes(link.node_start, link.node_end)
		dy_norm = dy / window.distanceBetweenNodes(link.node_start, link.node_end)
		# 3) we compute the point corresponding to the intersection of the arrow and the circle
		end_x = link.node_end.x + (-dx_norm * link.node_end.radius)
		end_y = link.node_end.y + (-dy_norm * link.node_end.radius)

		# we compute the two other points corresponding to the sides of the arrow:
		# 1) arrow coefficients
		length = 10*Math.sqrt(3)  # length of the arrow head
		half_width = 10           # half width of the arrow head
		# 2) let's compute a unit vector perpendicular to the line
		perp_x = -dy_norm
		perp_y =  dx_norm
		# 3) now we can compute the points
		point1_x = end_x - length*dx_norm + half_width*perp_x
		point1_y = end_y - length*dy_norm + half_width*perp_y
		point2_x = end_x - length*dx_norm - half_width*perp_x
		point2_y = end_y - length*dy_norm - half_width*perp_y

		# we draw the points
		context.moveTo(end_x, end_y)
		context.lineTo(point1_x, point1_y)
		context.moveTo(end_x, end_y)
		context.lineTo(point2_x, point2_y)

