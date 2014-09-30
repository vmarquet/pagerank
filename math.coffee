# to compute the distance between two nodes on the screen
window.distance = (node1, node2) ->
	ecart_x = node1.x - node2.x
	ecart_y = node1.y - node2.y
	return Math.sqrt(ecart_x*ecart_x + ecart_y*ecart_y)

# to compute the distance between two points on the screen
window.distance = (x1, y1, x2, y2) ->
	ecart_x = x1 - x2
	ecart_y = y1 - y2
	return Math.sqrt(ecart_x*ecart_x + ecart_y*ecart_y)

