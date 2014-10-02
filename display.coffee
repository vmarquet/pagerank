---
---

# the drawing function
window.animate = (canvas, context, node_list, link_list, userVector) ->

	# we draw the white background
	context.beginPath()
	context.strokeStyle = 'white'
	context.rect(0,0, canvas.width, canvas.height)
	context.fillStyle = 'white'
	context.fill()
	context.stroke()
	context.closePath()


	# we draw a rectangle to delimitate the drawing zone
	context.beginPath()
	context.strokeStyle = 'black'
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
		window.drawArrow(link, context)  # to draw the arrow at the end of the link

	context.stroke()
	context.closePath()

	# we compute all the node's colors
	window.computeNodeColor(userVector, node_list)

	# we draw all circles
	for node in node_list
		context.beginPath()
		context.strokeStyle = node.color
		context.moveTo(node.x, node.y)
		context.arc(node.x, node.y, node.radius, 0, 2 * Math.PI)
		context.fillStyle = node.color
		context.fill()
		context.stroke()
		context.closePath()
	
	


# a function to draw a line with an arrow at the end
window.drawArrow = (link, context) ->
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


# to compute a node's color according to it's PageRank
window.computeNodeColor = (userVector, node_list) ->
	# we convert the coefficient to color
	# 1) we compute the minimum coefficient
	minimum = 1
	for coef in userVector
		if coef < minimum
			minimum = coef
	# 2) we compute the maximum coefficient
	maximum = 0
	for coef in userVector
		if coef > maximum
			maximum = coef
	# 3) we compute the margin between min and max
	margin = maximum - minimum

	# to avoid dividing by 0 later
	if margin is 0
		for node in node_list
			node.color = 'yellow'
		return

	# we convert the coefficients to spread them from 0 to 1
	coef2 = []
	i = 0
	while i < userVector.length
		coef = userVector[i]
		coef2[i] = (coef - minimum) / (maximum - minimum)
		i++

	# we convert to a color between red and green
	i = 0
	while i < coef2.length
		if coef2[i] > 0.5
			# we convert the coef to something between 0 and 1
			coef2[i] -= 0.5
			coef2[i] *= 2

			R = Math.floor(255 - 255*coef2[i])
			G = 255
			B = 0

		else  # coef2[i] between 0 and 0.5
			# we convert the coef to something between 0 and 1
			coef2[i] *= 2

			R = 255
			G = Math.floor(coef2[i]*255)
			B = 0

		# we set the node's color
		node_list[i].color = 'rgb(' + R + ',' + G + ',' + B + ')'

		i++
