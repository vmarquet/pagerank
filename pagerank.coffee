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
					if window.distance(node.x, node.y, x, y) < 2*node.radius
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
					if window.distance(node.x, node.y, x, y) < 2*node.radius

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
	window.animate = () ->
		
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

	myInterval = setInterval(window.animate, 1000/10)  # 10 FPS