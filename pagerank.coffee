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
	
	matrix = []
	userVector = []

	linkingFlags = {linking: false}
	
	# jQuery code to get mouse clicks
	$('#myCanvas').mousedown((mouseEvent) ->
		# we get the mouse position
		$div = $(mouseEvent.target)
		offset = $div.offset()
		x = mouseEvent.clientX - offset.left
		y = mouseEvent.clientY - offset.top

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
					computePageRank()  # we compute PageRank again
				
	)
	$('#myCanvas').mouseup((mouseEvent) ->
		# we get the mouse position
		$div = $(mouseEvent.target)
		offset = $div.offset()
		x = mouseEvent.clientX - offset.left
		y = mouseEvent.clientY - offset.top

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
						# we check that the nodes weren't already linked
						alreadyLinked = false
						for link in link_list
							if link.node_start == linkingFlags.node_start and link.node_end == node
								alreadyLinked = true
								break
						if alreadyLinked is true
							break

						# we create a link between the two nodes
						link = new Link(linkingFlags.node_start, node)

						link_list.push(link)
						computePageRank()  # we compute PageRank again
						break
				
				linkingFlags.linking = false  # reset flag
	)
	$('#clearButton').click(() ->
		# we clear the display
		node_list = []
		link_list = []
	)

	# we compute the pagerank of each node
	computePageRank = () ->
		updateMatrix()   # http://en.wikipedia.org/wiki/Stochastic_matrix

		userVector = []
		i = 0
		while i < node_list.length
			userVector[i] = 1 / node_list.length
			i++

		i = 0
		while i < 10  # TODO: we should stop given a condition about if userVector converges or not
			newClickOnLink()
			i++

		updateNodesSize()

		printMatrix()
		printUserVector()


	# we update the stochastic matrix, in case user added pages (nodes) or links between pages
	updateMatrix = () ->
		# we create a new matrix
		matrix = []
		i = 0
		while i < node_list.length
			matrix[i] = []
			i++

		i = 0
		while i < node_list.length

			# we count the number of links to another page, from this page
			n = 0
			for link in link_list
				if link.node_start is node_list[i]
					n++

			# we update coefficients for the current line in the matrix
			j = 0
			while j < node_list.length
				# if n = 0 (no link to another the page), user should not be locked on the page,
				# so user is redirected on an other page (all pages with same probability)
				if n is 0
					if node_list.length is 1
						matrix[i][j] = 1
					else  # we only make links to another page, not to the same page
						if j is i
							matrix[i][j] = 0
						else
							matrix[i][j] = 1 / (node_list.length - 1)
				else
					# we search if the pages are linked
					linked = false
					for link in link_list
						if link.node_start is node_list[i] and link.node_end is node_list[j]
							matrix[i][j] = 1 / n
							linked = true
							break
					if linked is false
						matrix[i][j] = 0
				j++
			i++


	newClickOnLink = () ->
		i = 0
		userVectorNew = []
		while i < node_list.length
			userVectorNew[i] = 0
			j = 0
			while j < node_list.length
				userVectorNew[i] += userVector[j] * matrix[j][i]
				j++
			i++
		userVector = userVectorNew


	updateNodesSize = () ->
		i = 0
		while i < node_list.length
			node_list[i].radius = 50 * userVector[i] + 10
			i++


	setInterval(`function() {window.animate(canvas, context, node_list, link_list, userVector)}`, 1000/10)
	# the drawing function (in file display.coffee) will be called with a framerate of 10 FPS


	printMatrix = () ->   # debug
		console.log("===== matrix ======")
		# we round the coefficient for a better display
		i = 0
		while i < matrix.length
			j = 0
			while j < matrix[i].length
				matrix[i][j] = matrix[i][j].toFixed(2)
				j++
			i++

		# we display the matrix in a console (ctrl + shift + s -> display console in firefox)
		i = 0
		while i < matrix.length
			console.log(matrix[i])
			i++

	printUserVector = () ->   # debug
		console.log("===== user vector =====")
		# we round coefficients for a better display
		i = 0
		while i < userVector.length
			userVector[i] = userVector[i].toFixed(2)
			i++
		console.log(userVector)
