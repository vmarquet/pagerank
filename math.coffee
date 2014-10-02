---
---

# to compute the distance between two nodes on the screen
window.distanceBetweenNodes = (node1, node2) ->
	dx = node1.x - node2.x
	dy = node1.y - node2.y
	return Math.sqrt(dx*dx + dy*dy)

# to compute the distance between two points on the screen
window.distanceBetweenPoints = (x1, y1, x2, y2) ->
	dx = x1 - x2
	dy = y1 - y2
	return Math.sqrt(dx*dx + dy*dy)

