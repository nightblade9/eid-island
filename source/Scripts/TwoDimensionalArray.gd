extends Node

var width = 0
var height = 0
var data = [] # Simplest is best. One-dimensional array of length w * h

func _init(width, height):
	self.data = []
	self.width = width
	self.height = height

	# Initialize array with nulls
	for i in range(self.width * self.height):
		self.data.append(null)
	
func load_from(rows):
	self.height = rows.size()
	
	var max_width_seen = rows[0].size();
	for row in rows:
		var row_width = row.size()
		if row_width > max_width_seen:
			max_width_seen = row_width
	
	self.width = max_width_seen
	self._init(self.width, self.height)
	
	for y in range(rows.size()):
		var row = rows[y]
		for x in range(row.size()):
			var element = row[x]
			var index = (y * self.width) + x
			self.data[index] = element
	
func get(x, y):
	return self.data[x][y]

func set(x, y, item):
	self.data[x][y] = item
	
func find(item):
	var index = self.data.find(item)
	if index > -1:
		var x = index % self.width
		var y = int(index / self.width)
		return Vector2(x, y)
	else:
		return null # not found
		