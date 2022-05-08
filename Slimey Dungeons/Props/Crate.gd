extends Spatial


export var size := 10

func _ready():
	$CollisionShape.scale = Vector3(size, size, size)
	self.mass = size
	$Viewport/Size.text = str(size)
